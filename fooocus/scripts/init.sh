#! /bin/bash

echo "初始化一下，请稍等一下……"

target_model_dir="/root/autodl-tmp/models"

mkdir -p $target_model_dir
cd $target_model_dir

if [ ! -d "$target_model_dir/checkpoint" ]; then
  cg down tzwm/StableDiffusion-checkpoints/sd_xl_base_1.0_0.9vae.safetensors
  cg down tzwm/StableDiffusion-checkpoints/sd_xl_refiner_1.0_0.9vae.safetensors
  cg down tzwm/StableDiffusion-checkpoints/realisticStockPhoto_v10.safetensors
  cg down tzwm/StableDiffusion-checkpoints/bluePencilXL_v050.safetensors
  cg down tzwm/StableDiffusion-checkpoints/DreamShaper_8_pruned.safetensors
  mv StableDiffusion-checkpoints $target_model_dir/checkpoint
fi

if [ ! -d "$target_model_dir/loras" ]; then
  cg down tzwm/StableDiffusion-LoRAs/sd_xl_offset_example-lora_1.0.safetensors
  cg down tzwm/StableDiffusion-LoRAs/SDXL_FILM_PHOTOGRAPHY_STYLE_BetaV0.4.safetensors
  mv StableDiffusion-LoRAs $target_model_dir/loras
fi

echo "初始化完成"
