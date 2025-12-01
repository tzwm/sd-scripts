#! /bin/bash

echo "启动中……"

# echo "ollama 启动"
# ollama serve &

cd /root/autodl-tmp/ComfyUI

source /root/tzwm-scripts/common/scripts/init-proxy.sh && \
python main.py --port 6006 --listen 0.0.0.0 --enable-cors-header '*'
