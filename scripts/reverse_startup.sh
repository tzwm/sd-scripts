#!/bin/bash

# 定义公共 base_path 变量
base_source_path="/root/stable-diffusion-webui"
base_destination_path="/root/autodl-tmp/models"

# 定义所有相对于 base_path 的 A 和 B 的路径
paths=(
#  "extensions/sd-webui-controlnet/models controlnet"
  "models/Stable-diffusion ckpt"
  "models/Lora lora"
  "models/VAE vae"
)

mkdir -p "$base_destination_path"

for path in "${paths[@]}"; do
  # 将字符串拆分成两个变量，分别对应相对于 base_path 的 A 和 B 路径
  read -r source destination <<< "$path"

  # 拼接出实际的 A 和 B 路径
  source="$base_source_path/$source"
  destination="$base_destination_path/$destination"

  # 判断目标文件夹是否存在
  if [ ! -d "$source" ]; then
    cp -r "$destination" "$source"
    echo "cp -r $destination to $source"
  else
    # rm -r "$source"
    echo "$source is exist"
  fi
done
