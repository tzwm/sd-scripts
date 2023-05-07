#! /bin/bash

mkdir -p /root/autodl-tmp/webui_outputs

echo "重启中，需要等待几秒……"


pgrep -f 'launch.py' | head -n 1 | xargs kill

sleep 4

cd /root/stable-diffusion-webui/ && ./webui.sh -f
