#! /bin/bash

echo "启动中……"

source /etc/network_turbo

root_dir="/root/GPT4V-Image-Captioner"

cd $root_dir
python gpt-caption.py
