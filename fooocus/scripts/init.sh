#! /bin/bash

echo "初始化一下"

target_model_dir="/root/autodl-tmp/models"
source_model_dir="/root/Fooocus/models"

mkdir -p $target_model_dir

if [ ! -d "$target_model_dir/checkpoint" ]; then
  mv $source_model_dir/checkpoints $target_model_dir/checkpoints
  ln -s $target_model_dir/checkpoints $source_model_dir/checkpoints
fi

if [ ! -d "$target_model_dir/loras" ]; then
  mv $source_model_dir/loras $target_model_dir/loras
  ln -s $target_model_dir/loras $source_model_dir/loras
fi

echo "初始化完成"
