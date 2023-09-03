#! /bin/bash

model_dir="/root/autodl-tmp/models"

echo "下载 SDXL base、refiner、VAE 和 LoRA 模型"
mkdir -p $model_dir
cd $model_dir

mkdir -p $model_dir/checkpoint
cg down tzwm/stable-diffusion-xl-1.0/sd_xl_base_1.0.safetensors -t $model_dir
cg down tzwm/stable-diffusion-xl-1.0/sd_xl_refiner_1.0.safetensors -t $model_dir
mv "stable-diffusion-xl-1.0/sd_xl_base_1.0.safetensors" checkpoint/
mv "stable-diffusion-xl-1.0/sd_xl_refiner_1.0.safetensors" checkpoint/

mkdir -p $model_dir/vae
cg down tzwm/stable-diffusion-xl-1.0/sdxl_vae.safetensors -t $model_dir
mv "stable-diffusion-xl-1.0/sdxl_vae.safetensors" vae/

mkdir -p $model_dir/lora
cg down tzwm/stable-diffusion-xl-1.0/sd_xl_offset_example-lora_1.0.safetensors -t $model_dir
mv "stable-diffusion-xl-1.0/sd_xl_offset_example-lora_1.0.safetensors" lora/

rm -r stable-diffusion-xl-1.0
echo "下载完成，已经放入对应的目录"
