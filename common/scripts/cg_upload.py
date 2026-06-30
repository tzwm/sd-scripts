#!/usr/bin/env python3
"""
CodeWithGPU 上传脚本（绕过已下线的 cg CLI，直连 web API）。

链路：
  1. POST https://www.codewithgpu.com/api/v1/file/before_upload
     -> 秒传判断；未命中则返回 oss host + filetoken
  2. POST https://oss.codewithgpu.com:8000/api/v1/file        (init 分片任务)
  3. PUT  https://oss.codewithgpu.com:8000/api/v1/file        (逐片 multipart)
  4. (可选) PUT https://www.codewithgpu.com/api/v1/model      (创建/更新模型并绑定文件)

鉴权：环境变量 CG_AUTH_TOKEN（主站 JWT）。OSS 步骤用 step1 返回的 filetoken。

关于 model 字段语义：
  - file_list 是追加语义（只会增加，不会删除同名/旧文件，需要手动在网页清理）
  - describe / readme / cover / source_addr 是覆盖语义
  - 默认会先 GET 现有 model，未传的元信息字段以现有值兜底，避免被置空；
    加 --reset 则不做兜底。

用法：
  # 仅上传文件到 OSS，打印 md5
  CG_AUTH_TOKEN=xxx ./cg_upload.py file ./model.bin

  # 上传若干文件 + 创建/更新模型（现有元信息自动保留）
  CG_AUTH_TOKEN=xxx ./cg_upload.py model my_model \
      --file a.bin --file b.json \
      --source-addr https://huggingface.co/foo/bar \
      --readme ./README.md
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
import time
import uuid
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable, TypeVar
from urllib import request as urlrequest
from urllib.error import HTTPError

MAIN_HOST = "https://www.codewithgpu.com"
DEFAULT_CHUNK_SIZE = 4 * 1024 * 1024  # 4 MiB
MAX_RETRY = 3
RETRY_BACKOFF = 1.5
HASH_BUF = 1024 * 1024

T = TypeVar("T")


# ---------- 基础工具 ----------

def log(msg: str) -> None:
    print(msg, file=sys.stderr, flush=True)


def parse_size(s: str) -> int:
    s = s.strip().upper()
    units = {"K": 1024, "M": 1024 ** 2, "G": 1024 ** 3}
    if s and s[-1] in units:
        return int(float(s[:-1]) * units[s[-1]])
    return int(s)


def file_md5(path: Path) -> str:
    h = hashlib.md5()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(HASH_BUF), b""):
            h.update(chunk)
    return h.hexdigest()


def http_request(method: str, url: str, *,
                 headers: dict[str, str] | None = None,
                 body: bytes | None = None,
                 timeout: int = 60) -> tuple[int, bytes]:
    req = urlrequest.Request(url, data=body, method=method, headers=headers or {})
    try:
        with urlrequest.urlopen(req, timeout=timeout) as resp:
            return resp.status, resp.read()
    except HTTPError as e:
        return e.code, e.read()


def _check_business(method: str, url: str, status: int, data: dict[str, Any]) -> None:
    code = data.get("code")
    ok_codes = ("Success", "success", 0, "0")
    if status >= 400 or (code is not None and code not in ok_codes):
        raise RuntimeError(f"{method} {url} failed: HTTP {status} {data}")


def request_json(method: str, url: str, *,
                 auth: str | None = None,
                 filetoken: str | None = None,
                 payload: dict[str, Any] | None = None,
                 timeout: int = 60) -> dict[str, Any]:
    headers = {
        "accept": "application/json, text/plain, */*",
        "content-type": "application/json",
        "origin": MAIN_HOST,
        "referer": f"{MAIN_HOST}/",
        "user-agent": "cg_upload.py/0.1",
    }
    if auth:
        headers["authorization"] = auth
    if filetoken:
        headers["filetoken"] = filetoken

    body = json.dumps(payload or {}, ensure_ascii=False).encode("utf-8")
    status, raw = http_request(method, url, headers=headers, body=body, timeout=timeout)
    try:
        data = json.loads(raw.decode("utf-8"))
    except Exception as e:
        raise RuntimeError(f"HTTP {status} non-JSON response: {raw[:300]!r}") from e
    _check_business(method, url, status, data)
    return data


def retry(fn: Callable[[], T], *, what: str) -> T:
    last_err: Exception | None = None
    for attempt in range(1, MAX_RETRY + 1):
        try:
            return fn()
        except Exception as e:
            last_err = e
            if attempt == MAX_RETRY:
                break
            wait = RETRY_BACKOFF ** attempt
            log(f"  ! {what} attempt {attempt} failed: {e}; retry in {wait:.1f}s")
            time.sleep(wait)
    raise RuntimeError(f"{what} failed after {MAX_RETRY} attempts: {last_err}")


# ---------- multipart 拼装 ----------

def build_multipart(fields: list[tuple[str, str]],
                    file_field: str,
                    filename: str,
                    content_type: str,
                    payload: bytes) -> tuple[bytes, str]:
    boundary = "----cgUpload" + uuid.uuid4().hex
    crlf = b"\r\n"
    buf = bytearray()
    for name, value in fields:
        buf.extend(f"--{boundary}\r\n".encode())
        buf.extend(f'Content-Disposition: form-data; name="{name}"\r\n\r\n'.encode())
        buf.extend(value.encode("utf-8"))
        buf.extend(crlf)
    buf.extend(f"--{boundary}\r\n".encode())
    buf.extend(
        f'Content-Disposition: form-data; name="{file_field}"; filename="{filename}"\r\n'
        f"Content-Type: {content_type}\r\n\r\n".encode()
    )
    buf.extend(payload)
    buf.extend(crlf)
    buf.extend(f"--{boundary}--\r\n".encode())
    return bytes(buf), f"multipart/form-data; boundary={boundary}"


# ---------- 业务步骤 ----------

@dataclass
class UploadResult:
    md5: str
    filename: str
    quickly_upload: bool


def before_upload(auth: str, md5: str, size: int) -> dict[str, Any]:
    return request_json(
        "POST",
        f"{MAIN_HOST}/api/v1/file/before_upload",
        auth=auth,
        payload={"md5": md5, "file_size": size},
    )["data"]


def init_chunk_task(host: str, filetoken: str, md5: str,
                    total_size: int, chunks: int) -> None:
    request_json(
        "POST",
        f"{host}/api/v1/file",
        filetoken=filetoken,
        payload={"md5": md5, "total_size": total_size, "chunks": chunks},
    )


def put_chunk(host: str, filetoken: str, *,
              filename: str, md5: str, total_size: int,
              chunk_index: int, chunks: int,
              chunk_bytes: bytes, file_index: int) -> None:
    last_modified = time.strftime(
        "%a %b %d %Y %H:%M:%S GMT+0000 (UTC)", time.gmtime()
    )
    fields = [
        ("id", f"WU_FILE_{file_index}"),
        ("name", filename),
        ("type", "application/octet-stream"),
        ("lastModifiedDate", last_modified),
        ("size", str(total_size)),
        ("md5", md5),
        ("chunk", str(chunk_index)),
        ("chunks", str(chunks)),
        ("chunk_size", str(len(chunk_bytes))),
    ]
    body, ctype = build_multipart(
        fields,
        file_field="file",
        filename=filename,
        content_type="application/octet-stream",
        payload=chunk_bytes,
    )
    headers = {
        "accept": "*/*",
        "content-type": ctype,
        "filetoken": filetoken,
        "origin": MAIN_HOST,
        "referer": f"{MAIN_HOST}/",
        "user-agent": "cg_upload.py/0.1",
    }
    status, raw = http_request("PUT", f"{host}/api/v1/file",
                               headers=headers, body=body, timeout=600)
    if status >= 400:
        raise RuntimeError(f"chunk {chunk_index} HTTP {status}: {raw[:300]!r}")
    try:
        data = json.loads(raw.decode("utf-8"))
    except json.JSONDecodeError:
        return
    code = data.get("code")
    if code is not None and code not in ("Success", "success", 0, "0"):
        raise RuntimeError(f"chunk {chunk_index} business error: {data}")


def upload_file(auth: str, path: Path, *,
                chunk_size: int, file_index: int = 0) -> UploadResult:
    size = path.stat().st_size
    log(f"[{path.name}] size={size} computing md5 ...")
    md5 = file_md5(path)
    log(f"[{path.name}] md5={md5}")

    info = retry(lambda: before_upload(auth, md5, size), what="before_upload")
    if info.get("quickly_upload"):
        log(f"[{path.name}] quick upload hit, skip")
        return UploadResult(md5=md5, filename=path.name, quickly_upload=True)

    host = info["host"]
    filetoken = info["token"]
    chunks = max(1, (size + chunk_size - 1) // chunk_size)
    log(f"[{path.name}] init chunks={chunks} chunk_size={chunk_size} host={host}")
    retry(lambda: init_chunk_task(host, filetoken, md5, size, chunks),
          what="init_chunk_task")

    with path.open("rb") as f:
        for idx in range(chunks):
            buf = f.read(chunk_size)
            if not buf:
                break

            def _do(_buf: bytes = buf, _idx: int = idx) -> None:
                put_chunk(host, filetoken,
                          filename=path.name, md5=md5,
                          total_size=size, chunk_index=_idx, chunks=chunks,
                          chunk_bytes=_buf, file_index=file_index)

            retry(_do, what=f"put_chunk[{idx + 1}/{chunks}]")
            log(f"[{path.name}] uploaded {idx + 1}/{chunks}")

    log(f"[{path.name}] done")
    return UploadResult(md5=md5, filename=path.name, quickly_upload=False)


def get_model(auth: str, name: str) -> dict[str, Any] | None:
    """读取已有 model 详情；不存在则返回 None。"""
    from urllib.parse import quote
    url = f"{MAIN_HOST}/api/v1/model?name={quote(name)}"
    try:
        data = request_json("GET", url, auth=auth)
    except RuntimeError as e:
        # 不存在时后端返回非 Success；当 "软失败" 处理
        log(f"  (model {name!r} not found or unreadable: {e})")
        return None
    return data.get("data")


def put_model(auth: str, *,
              name: str,
              new_name: str | None,
              file_list: list[dict[str, str]],
              source_addr: str = "",
              describe: str = "",
              cover: str = "",
              readme: str = "") -> dict[str, Any]:
    payload = {
        "name": name,
        "new_name": new_name or name,
        "source_addr": source_addr,
        "describe": describe,
        "cover": cover,
        "readme": readme,
        "file_list": file_list,
    }
    return request_json("PUT", f"{MAIN_HOST}/api/v1/model",
                        auth=auth, payload=payload)


# ---------- CLI ----------

def get_token() -> str:
    token = os.environ.get("CG_AUTH_TOKEN", "").strip()
    if not token:
        log("ERROR: please set env var CG_AUTH_TOKEN (CodeWithGPU JWT)")
        sys.exit(2)
    return token


def cmd_file(args: argparse.Namespace) -> int:
    auth = get_token()
    chunk_size = parse_size(args.chunk_size)
    results: list[UploadResult] = []
    for i, p in enumerate(args.paths):
        path = Path(p).expanduser().resolve()
        if not path.is_file():
            log(f"ERROR: not a file: {path}")
            return 2
        results.append(upload_file(auth, path, chunk_size=chunk_size, file_index=i))

    print(json.dumps([r.__dict__ for r in results], ensure_ascii=False, indent=2))
    return 0


def cmd_model(args: argparse.Namespace) -> int:
    auth = get_token()
    chunk_size = parse_size(args.chunk_size)

    # 先尝试拉一份现有 model 的元信息，做兜底，避免显式不传时把网页上原有的清掉。
    # 命令行参数优先级始终高于现有值；--reset 可强制忽略现有值。
    existing: dict[str, Any] = {}
    if not args.reset:
        info = get_model(auth, args.name)
        if info:
            existing = info
            log(f"  loaded existing model {args.name!r} "
                f"(file_list={len(info.get('file_list') or [])}, "
                f"describe={'Y' if info.get('describe') else 'N'}, "
                f"readme={'Y' if info.get('readme') else 'N'})")

    readme_text: str | None = None
    if args.readme:
        readme_path = Path(args.readme).expanduser().resolve()
        if not readme_path.is_file():
            log(f"ERROR: readme not found: {readme_path}")
            return 2
        readme_text = readme_path.read_text(encoding="utf-8")

    def pick(cli_value: str | None, existing_key: str, default: str = "") -> str:
        if cli_value is not None and cli_value != "":
            return cli_value
        v = existing.get(existing_key)
        return v if isinstance(v, str) and v else default

    file_list: list[dict[str, str]] = []
    for i, p in enumerate(args.files):
        path = Path(p).expanduser().resolve()
        if not path.is_file():
            log(f"ERROR: not a file: {path}")
            return 2
        result = upload_file(auth, path, chunk_size=chunk_size, file_index=i)
        file_list.append({
            "md5": result.md5,
            "filename": result.filename,
            "file_type": args.file_type,
        })

    final_source = pick(args.source_addr, "source_addr")
    final_describe = pick(args.describe, "describe")
    final_cover = pick(args.cover, "cover")
    final_readme = (
        readme_text
        if readme_text is not None
        else (existing.get("readme") or "")
    )

    log(f"binding {len(file_list)} file(s) to model {args.name!r} ...")
    log(f"  source_addr={final_source!r}")
    log(f"  describe={final_describe!r}")
    log(f"  cover={final_cover!r}")
    log(f"  readme=({len(final_readme)} chars)")
    resp = put_model(
        auth,
        name=args.name,
        new_name=args.new_name,
        file_list=file_list,
        source_addr=final_source,
        describe=final_describe,
        cover=final_cover,
        readme=final_readme,
    )
    print(json.dumps(resp, ensure_ascii=False, indent=2))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="CodeWithGPU 上传脚本（直连 web API）",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_file = sub.add_parser("file", help="仅上传文件到 OSS，打印 md5 列表")
    p_file.add_argument("paths", nargs="+", help="本地文件路径，可多个")
    p_file.add_argument("--chunk-size", default="4M",
                        help="分片大小，支持 K/M/G 后缀（默认 4M）")
    p_file.set_defaults(func=cmd_file)

    p_model = sub.add_parser("model", help="上传文件并创建/更新模型")
    p_model.add_argument("name", help="模型当前名（原 name）")
    p_model.add_argument("--new-name", default=None,
                         help="新模型名，缺省与 name 相同")
    p_model.add_argument("--file", dest="files", action="append", required=True,
                         help="本地文件路径，可重复指定")
    p_model.add_argument("--file-type", default="model",
                         help="file_type 字段（默认 model）")
    p_model.add_argument("--source-addr", default=None,
                         help="来源链接；不传且网上已有值则保留原值")
    p_model.add_argument("--describe", default=None,
                         help="简要描述；不传且网上已有值则保留原值")
    p_model.add_argument("--cover", default=None,
                         help="封面图 URL；不传且网上已有值则保留原值")
    p_model.add_argument("--readme", default=None,
                         help="README 文件路径；不传且网上已有值则保留原值")
    p_model.add_argument("--reset", action="store_true",
                         help="不读取现有 model 元信息作兜底，未传的字段会被置为空")
    p_model.add_argument("--chunk-size", default="4M",
                         help="分片大小，支持 K/M/G 后缀（默认 4M）")
    p_model.set_defaults(func=cmd_model)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        return args.func(args)
    except KeyboardInterrupt:
        log("interrupted")
        return 130
    except Exception as e:
        log(f"FATAL: {e}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
