#! /bin/bash

echo "开始初始化……"

if [ -d "/root/cache" ]; then
  rm -rf "/root/.cache/*"
  mv "/root/cache/huggingface" "/root/.cache/huggingface"
  mv "/root/cache/torch" "/root/.cache/torch"
  mv "/root/cache/matplotlib" "/root/.cache/matplotlib"
fi

echo "初始化成功"
