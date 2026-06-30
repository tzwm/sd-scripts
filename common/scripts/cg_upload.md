# cg_upload.py

CodeWithGPU 上传脚本，直连 web API，**不依赖**已被官方下线的 `cg` CLI 二进制。

替代 `upload_to_cg.sh`（基于旧版 `cgtool`，已无法工作）。

## 链路

1. `POST /api/v1/file/before_upload` — 秒传判断；未命中则返回 OSS host + filetoken
2. `POST oss.codewithgpu.com:8000/api/v1/file` — init 分片任务
3. `PUT  oss.codewithgpu.com:8000/api/v1/file` — 逐片 multipart 上传
4. （可选）`PUT /api/v1/model` — 创建/更新模型并绑定文件

## 准备

依赖：仅 Python 3.10+（标准库）。

设置 token（**主站 JWT**，浏览器开发者工具里抓任何 codewithgpu 请求的 `authorization` 头都行）：

```bash
export CG_AUTH_TOKEN='eyJhbGciOi...'
```

会过期，过期了重新抓一个即可。

## 用法

### 1. 仅上传文件到 OSS（不绑模型）

```bash
./cg_upload.py file ./model.bin
./cg_upload.py file a.safetensors b.safetensors --chunk-size 16M
```

打印每个文件的 md5，方便后续手工挂到 model。

### 2. 上传 + 创建/更新模型（最常用）

```bash
./cg_upload.py model my_model \
    --file ./weights.safetensors \
    --file ./config.json \
    --source-addr 'https://huggingface.co/foo/bar' \
    --readme ./README.md \
    --describe '简要描述'
```

- model 不存在会自动新建
- `--file` 可以重复指定
- `--readme` 后面是**本地文件路径**，脚本会读其内容塞到 `readme` 字段

### 3. 给已有 model 加新文件（不动元信息）

```bash
./cg_upload.py model my_model --file ./new_weights.safetensors
```

未传 `--source-addr / --describe / --readme / --cover` 时，脚本会**自动 GET 现有 model**，用现有值兜底，**不会**清空原有描述/README/封面/来源链接。

加 `--reset` 可强制忽略现有值，未传的字段就置空：

```bash
./cg_upload.py model my_model --file ./x.bin --reset
```

## API 语义重点

| 字段 | 行为 |
|---|---|
| `file_list` | **追加**——只增不减，**无法**通过本脚本删除旧文件，需要去网页手工删 |
| `describe` / `readme` / `cover` / `source_addr` | **覆盖**——未传时脚本默认用现有值兜底（除非 `--reset`） |
| `name` / `new_name` | `name` 是当前名，`new_name` 是改名后的新名，默认相同 |

## 常用技巧

- **大文件 / AutoDL 内网**：`--chunk-size 16M`（默认 4M）
- **远端长跑不掉**：
  ```bash
  nohup bash -c 'source ~/.cg_env && \
    ./cg_upload.py file big.safetensors > /root/cg.stdout 2>/root/cg.log' \
    >/dev/null 2>&1 &
  ```
  或者直接 `tmux`
- **查模型当前状态**：
  ```bash
  curl -sG "https://www.codewithgpu.com/api/v1/model?name=<MODEL>" \
       -H "authorization: $CG_AUTH_TOKEN" | python3 -m json.tool
  ```
- **秒传**：脚本会自动跳过云端已存在的相同 md5 文件，断点续跑友好（仅文件级别，单个大文件传到一半挂了仍需重传整文件）

## 不做的事

- 不并发上传分片（串行保证正确性，机房内网已经够快）
- 不做单个文件的 chunk 级别断点续传
- 不会删除 model 已挂的旧文件（接口没研究过，怕误伤）

## 历史背景

参考 `~/repositories/codewithgpu`（官方 SDK）。官方的 `cg upload` 在 2026 年后服务端关停，
错误信息是误导性的 `preupload: connect to server failed`，本脚本是网页端 API 的逆向最小实现。
