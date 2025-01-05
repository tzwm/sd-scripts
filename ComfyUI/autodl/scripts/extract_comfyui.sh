#! /bin/bash

echo "初始化 ComfyUI 路径..."
if [ -d "/root/autodl-tmp/ComfyUI" ]; then
  echo "数据盘已有 ComfyUI 路径，不再初始化 ComfyUI"
  exit
fi

if [ ! -e "/root/comfyui.tar" ]; then
  echo "没找到 /root/comfyui.tar 文件，初始化失败，请重新创建实例"
  exit 1
fi

tar -xf /root/comfyui.tar -C /root/autodl-tmp/
echo "初始化 ComfyUI 结束"
