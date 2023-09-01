#! /bin/bash

echo "初始化一下"

if [ ! -d "/root/autodl-tmp/checkpoints" ]; then
  mv /root/Fooocus/models/checkpoints /root/autodl-tmp/
  ln -s /root/autodl-tmp/checkpoints /root/Fooocus/models/
fi

echo "初始化完成"
