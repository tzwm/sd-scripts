#! /bin/bash

echo "开始初始化……"

if [ -d "/root/cache" ]; then
  rm -rf "/root/.cache"
  mv "/root/cache" "/root/.cache"
fi

echo "初始化成功"
