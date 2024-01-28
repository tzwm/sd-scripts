#! /bin/bash

model_dir="/root/autodl-tmp/"

cd $model_dir

if [ -e "cogagent-vqa-hf" ]; then
  echo "$model_dir/cogagent-vqa-hf 已存在"
fi

echo "开始下载，有点大稍等一会..."
cg down tzwm/cogagent-vqa-hf
echo "cogagent-vqa-hf 下载完成"
