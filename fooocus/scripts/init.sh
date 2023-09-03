#! /bin/bash

echo "初始化一下"

target_model_dir="/root/autodl-tmp/models"
source_model_dir="/root/Fooocus/models"

if [ ! -d "$target_model_dir/checkpoints" ]; then
  mv $source_model_dir/checkpoints $target_model_dir/
  ln -s $target_model_dir/checkpoints $source_model_dir/
fi

if [ ! -d "$target_model_dir/loras" ]; then
  mv $source_model_dir/loras $target_model_dir/
  ln -s $target_model_dir/loras $source_model_dir/
fi

echo "初始化完成"
