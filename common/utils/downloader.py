import os
import subprocess
import sys
import yaml

def cg_down(cg_path: str, target: str, tmp_path: str):
    filename = os.path.basename(cg_path)
    target_file = target + filename

    if os.path.exists(target_file):
        return

    os.makedirs(target, exist_ok=True)

    subprocess.run(f"cg down {cg_path} -t {tmp_path}", shell=True)

    tmp_file = f"{tmp_path}/{cg_path}"
    if target_file != tmp_file:
        subprocess.run(f"mv {tmp_file} {target_file}", shell=True)

    os.rmdir(f"{tmp_path}/{cg_path.split('/')[-2]}")

def rsync(source: str, target: str):
    os.makedirs(source, exist_ok=True)
    os.makedirs(target, exist_ok=True)

    subprocess.run([
        'rsync',
        '-av',
        '--ignore-existing',
        '--delete',
        source,
        target
    ])

def link(source: str, target: str):
    subprocess.run(f"ln -s {source} {target}", shell=True)


def prepare_init_files(filelist_path: str):
    data = yaml.safe_load(open(filelist_path, 'r').read())

    skip_mark = data['configs']['skip_mark_path']
    if os.path.exists(skip_mark):
        print(f"跳过 {data['configs']['name']} 模型初始化。想要重新初始化可以删除标记文件: {skip_mark}")
        return

    tmp_path = data['configs']['tmp_path']
    for c in data['files']:
        if c['type'] == 'codewithgpu':
            cg_down(c['cg_path'], c['target'], tmp_path)
            continue

        if c['type'] == 'rsync':
            rsync(c['source'], c['target'])
            continue

        if c['type'] == 'link':
            link(c['source'], c['target'])
            continue

    open(skip_mark, 'a').close()
    print(f"{data['configs']['name']} 初始化完成")

if __name__ == '__main__':
    if len(sys.argv) > 1:
        filelist_path = sys.argv[1]
    else:
        print('missing filelist path')
        exit(0)

    prepare_init_files(filelist_path)
