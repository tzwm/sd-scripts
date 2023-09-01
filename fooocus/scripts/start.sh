#! /bin/bash

echo "启动中……"

source /root/tzwm-autodl/common/scripts/init-proxy.sh && \
unset http_proxy https_proxy all_proxy && \
cd /root/Fooocus && source venv/bin/activate && python launch.py --port 6006 --listen 0.0.0.0
