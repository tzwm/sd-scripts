#! /bin/bash

model_dir="/root/autodl-tmp/models"
cg_repo="stable-diffusion-xl-1.0"

echo "下载 SDXL base、refiner、VAE 和 LoRA 模型"
mkdir -p $model_dir
cd $model_dir

function cgsdxl() {
  model_type=$1
  filename=$2

  mkdir -p $model_type
  if [ ! -f "$model_type/$filename" ]; then
    cg down tzwm/$cg_repo/$filename -t $model_dir
    mv "$cg_repo/$filename" $model_type/
  fi
}

cgsdxl "checkpoint" "sd_xl_base_1.0.safetensors"
cgsdxl "checkpoint" "sd_xl_refiner_1.0.safetensors"
cgsdxl "vae" "sdxl_vae.safetensors"
cgsdxl "lora" "sd_xl_offset_example-lora_1.0.safetensors"

if [ -d $cg_repo ]; then
  rm -r $cg_repo
fi

echo "下载完成，已经放入对应的目录"
