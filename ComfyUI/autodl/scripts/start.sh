#! /bin/bash

echo "启动中……"

output_dir="/root/autodl-tmp/output"
if [ ! -d $output_dir ]; then
  ln -s /root/ComfyUI/output $output_dir
fi

echo "ollama 启动"
nohup ollama serve &

cd /root/ComfyUI

source /root/tzwm-autodl/common/scripts/init-proxy.sh && \
HF_ENDPOINT=https://hf-mirror.com \
python main.py --port 6006 --listen 0.0.0.0
