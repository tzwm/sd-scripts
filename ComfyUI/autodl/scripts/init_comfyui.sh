#! /bin/bash

echo "初始化 ComfyUI 路径..."
if [ -d "/root/autodl-tmp/ComfyUI" ]; then
  echo "数据盘已有 ComfyUI 路径，不再初始化 ComfyUI"
  exit
fi

if [ ! -d "/root/ComfyUI" ]; then
  echo "系统盘预置 ComfyUI 路径已经被删除，请新开实例"
  exit
fi

mv /root/ComfyUI /root/autodl-tmp/
