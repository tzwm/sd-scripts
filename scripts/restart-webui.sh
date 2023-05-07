#! /bin/bash

pgrep -f 'webui.*.sh' | head -n 1 | xargs kill

echo "重启中，需要等待几秒……"
sleep 4

/root/stable-diffusion-webui/webui.sh
