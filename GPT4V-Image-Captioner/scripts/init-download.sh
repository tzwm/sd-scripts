#! /bin/bash

model_dir="/root/autodl-tmp/"

cd $model_dir

if [ -e "cogagent-vqa-hf" ]; then
  echo "$model_dir/cogagent-vqa-hf 已存在"
else
  echo -e "开始下载，有点大稍等一会...\n"
  cg down tzwm/cogagent-vqa-hf
  echo -e "cogagent-vqa-hf 下载完成\n"
fi

cache_backup_dir="/root/cache"
cache_dest_dir="/root/.cache"
if [ -d $cache_backup_dir ]; then
  mkdir -p $cache_dest_dir
  mv $cache_backup_dir/huggingface $cache_dest_dir/huggingface
  mv $cache_backup_dir/torch $cache_dest_dir/torch 2> /dev/null
  rm -r $cache_backup_dir

  echo -e "初始化完成"
fi
