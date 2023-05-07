#! /bin/bash

model_dir="/root/autodl-tmp/models"

if [ -d "$model_dir" ]; then
  echo "模型目录已存在，不重复下载"
  exit 0
fi


echo "首次使用需要下载一些基本的模型，应该挺快的，稍等一下"

cg down StableDiffusion-checkpoints/anything-v4.5-pruned-fp16.ckpt -t $model_dir
cg down StableDiffusion-VAE/anything-v4.0.vae.pt -t $model_dir
cg down StableDiffusion-LoRAs/makimaChainsawMan_offset.safetensors -t $model_dir
cg down StableDiffusion-Embeddings/easy_negative.safetensors -t $model_dir
cg down ControlNet-v1-1 -t $model_dir

cd $model_dir
mv StableDiffusion-checkpoints ckpt
mv StableDiffusion-VAE vae
mv StableDiffusion-LoRAs lora
mv StableDiffusion-Embeddings embeddings
mv ControlNet-v1-1 controlnet

echo "都下载好了，可以去启动了"

#controlnet_models_urls=(
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime.yaml"
#)

#for url in "${controlnet_models_urls[@]}"
#do
  #wget "$url"
#done
