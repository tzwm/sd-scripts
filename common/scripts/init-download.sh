#! /bin/bash

model_dir="/root/autodl-tmp/models"

mkdir -p $model_dir
cd $model_dir

if [ "$1" == "checkpoint" ] && [ ! -d "$model_dir/$1" ]; then
  cg down StableDiffusion-checkpoints/AnythingV5_v5PrtRE.safetensors -t $model_dir
  cg down tzwm/StableDiffusion-checkpoints/majicmixRealistic_v6.safetensors -t $model_dir
  mv StableDiffusion-checkpoints $1

  echo -e ">>>> checkpoints 搞定\n"
fi

if [ "$1" == "vae" ] && [ ! -d "$model_dir/$1" ]; then
  cg down StableDiffusion-VAE/vae-ft-mse-840000-ema-pruned.safetensors -t $model_dir
  cg down tzwm/StableDiffusion-VAE/anything-v4.0.vae.pt -t $model_dir
  mv StableDiffusion-VAE $1

  echo -e ">>>> VAE 搞定\n"
fi

if [ "$1" == "lora" ] && [ ! -d "$model_dir/$1" ]; then
  cg down StableDiffusion-LoRAs/makimaChainsawMan_offset.safetensors -t $model_dir
  mv StableDiffusion-LoRAs $1

  echo -e ">>>> lora 搞定\n"
fi

if [ "$1" == "embeddings" ] && [ ! -d "$model_dir/$1" ]; then
  cg down StableDiffusion-Embeddings/easy_negative.safetensors -t $model_dir
  mv StableDiffusion-Embeddings $1

  echo -e ">>>> embeddings 搞定\n"
fi

if [ "$1" == "controlnet" ] && [ ! -d "$model_dir/$1" ]; then
  cg down ControlNet-v1-1-diff -t $model_dir
  mv ControlNet-v1-1-diff $1

  cg down tzwm/ControlNet-others/control_v1p_sd15_brightness.safetensors -t $model_dir
  mv ControlNet-others/control_v1p_sd15_brightness.safetensors $1/
  cg down tzwm/ControlNet-others/control_v1p_sd15_illumination.safetensors -t $model_dir
  mv ControlNet-others/control_v1p_sd15_illumination.safetensors $1/
  cg down tzwm/ControlNet-others/controlnetQRPatternQR_v2Sd15.safetensors -t $model_dir
  mv ControlNet-others/controlnetQRPatternQR_v2Sd15.safetensors $1/
  rm -r ControlNet-others

  echo -e ">>>> controlnet 搞定\n"
fi

if [ "$1" == "lycoris" ] && [ ! -d "$model_dir/$1" ]; then
  cg down StableDiffusion-lycoris/InsPX.safetensors -t $model_dir
  mv StableDiffusion-lycoris $1

  echo -e ">>>> lycoris 搞定\n"
fi

function cgdown() {
  mkdir -p $1

  local data=$2
  echo "$data" | while read line; do
    target_path=$(echo $line | cut -d ',' -f 1)
    source_path=$(echo $line | cut -d ',' -f 2)

    cg down "StableDiffusion-others/$source_path" -t $model_dir
    mkdir -p $(dirname $target_path)

    mv "$model_dir/StableDiffusion-others/$source_path" $target_path
  done

  rm -r StableDiffusion-others
}

if [ "$1" == "controlnet_annotator" ] && [ ! -d "$model_dir/$1" ]; then
  data="controlnet_annotator/leres/res101.pth,res101.pth
controlnet_annotator/leres/latest_net_G.pth,latest_net_G.pth
controlnet_annotator/lineart_anime/netG.pth,netG.pth
controlnet_annotator/lineart/sk_model.pth,sk_model.pth
controlnet_annotator/lineart/sk_model2.pth,sk_model2.pth
controlnet_annotator/midas/dpt_hybrid-midas-501f0c75.pt,dpt_hybrid-midas-501f0c75.pt
controlnet_annotator/openpose/body_pose_model.pth,body_pose_model.pth
controlnet_annotator/openpose/hand_pose_model.pth,hand_pose_model.pth
controlnet_annotator/openpose/facenet.pth,facenet.pth
controlnet_annotator/openpose/dw-ll_ucoco_384.onnx,dw-ll_ucoco_384.onnx
controlnet_annotator/openpose/yolox_l.onnx,yolox_l.onnx
controlnet_annotator/hed/ControlNetHED.pth,ControlNetHED.pth
controlnet_annotator/zoedepth/ZoeD_M12_N.pt,ZoeD_M12_N.pt
controlnet_annotator/manga_line/erika.pth,erika.pth
controlnet_annotator/mlsd/mlsd_large_512_fp32.pth,mlsd_large_512_fp32.pth
controlnet_annotator/normal_bae/scannet.pt,scannet.pt
controlnet_annotator/pidinet/table5_pidinet.pth,table5_pidinet.pth
controlnet_annotator/oneformer/250_16_swin_l_oneformer_ade20k_160k.pth,250_16_swin_l_oneformer_ade20k_160k.pth
controlnet_annotator/oneformer/150_16_swin_l_oneformer_coco_100ep.pth,150_16_swin_l_oneformer_coco_100ep.pth
controlnet_annotator/lama/ControlNetLama.pth,ControlNetLama.pth
controlnet_annotator/uniformer/upernet_global_small.pth,upernet_global_small.pth"

  cgdown "$1" "$data"

  rm -r /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads
  ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads

  echo -e ">>>> ControlNet Annotator 模型搞定\n"
fi


if [ "$1" == "segment_anything" ] && [ ! -d "$model_dir/$1" ]; then
  data="segment_anything/grounding-dino/GroundingDINO_SwinT_OGC.py,GroundingDINO_SwinT_OGC.py
segment_anything/grounding-dino/groundingdino_swint_ogc.pth,groundingdino_swint_ogc.pth
segment_anything/sam/sam_vit_h_4b8939.pth,sam_vit_h_4b8939.pth"

  cgdown "$1" "$data"

  rm -r /root/stable-diffusion-webui/extensions/sd-webui-segment-anything/models
  ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/sd-webui-segment-anything/models

  echo -e ">>>> Segment Anything 模型搞定"
  echo -e ">>>> GroundingDINO 模型搞定\n"
fi

if [ "$1" == "Deforum" ] && [ ! -d "$model_dir/$1" ]; then
  data="Deforum/AdaBins_nyu.pt,AdaBins_nyu.pt
Deforum/dpt_large-midas-2f21e586.pt,dpt_large-midas-2f21e586.pt"

  cgdown "$1" "$data"

  rm -r /root/stable-diffusion-webui/models/Deforum
  ln -s $model_dir/$1 /root/stable-diffusion-webui/models/Deforum

  echo -e ">>>> Deforum 模型搞定\n"
fi

if [ "$1" == "SadTalker" ] && [ ! -d "$model_dir/$1" ]; then
  data="SadTalker/mapping_00109-model.pth.tar,mapping_00109-model.pth.tar
SadTalker/mapping_00229-model.pth.tar,mapping_00229-model.pth.tar
SadTalker/SadTalker_V0.0.2_256.safetensors,SadTalker_V0.0.2_256.safetensors
SadTalker/SadTalker_V0.0.2_512.safetensors,SadTalker_V0.0.2_512.safetensors"

  cgdown "$1" "$data"

  rm -r /root/stable-diffusion-webui/extensions/SadTalker/checkpoints
  ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/SadTalker/checkpoints

  echo -e ">>>> SadTalker 模型搞定\n"
fi

if [ "$1" == "AnimateDiff" ] && [ ! -d "$model_dir/$1" ]; then
  data="AnimateDiff/mm_sd_v15.ckpt,mm_sd_v15.ckpt"

  cgdown "$1" "$data"

  rm -r /root/stable-diffusion-webui/extensions/sd-webui-animatediff/model
  ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/sd-webui-animatediff/model

  echo -e ">>>> AnimateDiff 模型搞定\n"
fi


cache_backup_dir="/root/cache"
cache_dest_dir="/root/.cache"
if [ "$1" == "cache" ] && [ -d $cache_backup_dir ]; then
  mkdir -p $cache_dest_dir
  mv $cache_backup_dir/huggingface $cache_dest_dir/huggingface
  mv $cache_backup_dir/clip $cache_dest_dir/clip
  mv $cache_backup_dir/torch $cache_dest_dir/torch
  rm -r $cache_backup_dir

  echo -e ">>>> CLIP 和 tagger 模型搞定\n"
fi
