#! /bin/bash

echo "启动中……"

mkdir -p /root/autodl-tmp/outputs

cd /root/ComfyUI

source /root/tzwm-autodl/common/scripts/init-proxy.sh && \
python main.py --port 6006 --listen 0.0.0.0
