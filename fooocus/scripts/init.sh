#! /bin/bash

echo "初始化一下"

target_model_dir="/root/autodl-tmp/models"
source_model_dir="/root/Fooocus/models"

mkdir -p $target_model_dir

if [ ! -d "$target_model_dir/checkpoint" ]; then
  mv $source_model_dir/checkpoints $target_model_dir/checkpoint
  ln -s $target_model_dir/checkpoint $source_model_dir/checkpoints

  cg down tzwm/StableDiffusion-checkpoints/realisticStockPhoto_v10.safetensors
  cg down tzwm/StableDiffusion-checkpoints/bluePencilXL_v050.safetensors
  cg down tzwm/StableDiffusion-checkpoints/DreamShaper_8_pruned.safetensors
  mv StableDiffusion-checkpoints/* $target_model_dir/checkpoint
  rm -r StableDiffusion-checkpoints
fi

if [ ! -d "$target_model_dir/loras" ]; then
  mv $source_model_dir/loras $target_model_dir/loras
  ln -s $target_model_dir/loras $source_model_dir/loras

  cg down tzwm/StableDiffusion-LoRAs/SDXL_FILM_PHOTOGRAPHY_STYLE_BetaV0.4.safetensors
  mv StableDiffusion-LoRAs/* $target_model_dir/loras
  rm -r StableDiffusion-LoRAs
fi

echo "初始化完成"
