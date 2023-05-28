#! /bin/bash

mkdir -p /root/autodl-tmp/webui_outputs

echo "重启中，需要等待几秒……"


pgrep -f 'launch.py' | head -n 1 | xargs kill

sleep 4

cd /root/stable-diffusion-webui/ && ./webui.sh -f --port 6006 --disable-safe-unpickle --ckpt /root/autodl-tmp/models/StableDiffusion-checkpoints/anything-v4.5-pruned-fp16.ckpt --skip-update
