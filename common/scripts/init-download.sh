#! /bin/bash

model_dir="/root/autodl-tmp/models"

mkdir -p $model_dir
cd $model_dir

cg upgrade

# model_type, data(dir, cg_name), cg_repo, [optional]target_dir
function cgdown() {
  mkdir -p $1

  local data=$2
  local target_dir="$1"
  if [ -n "$4" ]; then
    target_dir="$4"
  fi
  echo "$data" | while read line; do
    target_path="$target_dir/$(echo $line | cut -d ',' -f 1)"
    source_path=$(echo $line | cut -d ',' -f 2)

    if [ -e "$target_path" ]; then
      continue
    fi

    cg down "$3/$source_path" -t $model_dir
    mkdir -p $(dirname $target_path)

    mv "$model_dir/$3/$source_path" $target_path
  done

  rm -r $3
}

# input, model_type, data(dir, cg_name), cg_repo
function check_and_download() {
  if [ "$1" == "$2" ]; then
    cgdown "$1" "$3" "$4"
  fi

  echo -e ">>>> $1 搞定\n"
}


data="AnythingV5_v5PrtRE.safetensors,AnythingV5_v5PrtRE.safetensors
majicmixRealistic_v6.safetensors,majicmixRealistic_v6.safetensors"
check_and_download "$1" "checkpoint" "$data" "StableDiffusion-checkpoints"


data="vae-ft-mse-840000-ema-pruned.safetensors,vae-ft-mse-840000-ema-pruned.safetensors
anything-v4.0.vae.pt,anything-v4.0.vae.pt"
check_and_download "$1" "vae" "$data" "StableDiffusion-VAE"


data="pensketch_lora_v2.3.safetensors,pensketch_lora_v2.3.safetensors"
check_and_download "$1" "lora" "$data" "StableDiffusion-LoRAs"


data="easy_negative.safetensors,easy_negative.safetensors"
check_and_download "$1" "embeddings" "$data" "StableDiffusion-Embeddings"


#controlnet sd1.5
data="control_v11f1e_sd15_tile_fp16.safetensors,control_v11f1e_sd15_tile_fp16.safetensors
control_v11f1p_sd15_depth_fp16.safetensors,control_v11f1p_sd15_depth_fp16.safetensors
control_v11p_sd15_lineart_fp16.safetensors,control_v11p_sd15_lineart_fp16.safetensors
control_v11p_sd15_openpose_fp16.safetensors,control_v11p_sd15_openpose_fp16.safetensors
control_v11p_sd15_inpaint_fp16.safetensors,control_v11p_sd15_inpaint_fp16.safetensors
control_v11f1e_sd15_tile.yaml,control_v11f1e_sd15_tile.yaml
control_v11f1p_sd15_depth.yaml,control_v11f1p_sd15_depth.yaml
control_v11p_sd15_lineart.yaml,control_v11p_sd15_lineart.yaml
control_v11p_sd15_openpose.yaml,control_v11p_sd15_openpose.yaml
control_v11p_sd15_inpaint.yaml,control_v11p_sd15_inpaint.yaml"
#control_v11p_sd15_canny_fp16.safetensors,control_v11p_sd15_canny_fp16.safetensors
#control_v11e_sd15_ip2p_fp16.safetensors,control_v11e_sd15_ip2p_fp16.safetensors
#control_v11e_sd15_shuffle_fp16.safetensors,control_v11e_sd15_shuffle_fp16.safetensors
#control_v11p_sd15_mlsd_fp16.safetensors,control_v11p_sd15_mlsd_fp16.safetensors
#control_v11p_sd15_normalbae_fp16.safetensors,control_v11p_sd15_normalbae_fp16.safetensors
#control_v11p_sd15_scribble_fp16.safetensors,control_v11p_sd15_scribble_fp16.safetensors
#control_v11p_sd15_seg_fp16.safetensors,control_v11p_sd15_seg_fp16.safetensors
#control_v11p_sd15_softedge_fp16.safetensors,control_v11p_sd15_softedge_fp16.safetensors
#control_v11p_sd15s2_lineart_anime_fp16.safetensors,control_v11p_sd15s2_lineart_anime_fp16.safetensors
#control_v11p_sd15_canny.yaml,control_v11p_sd15_canny.yaml
#control_v11e_sd15_ip2p.yaml,control_v11e_sd15_ip2p.yaml
#control_v11e_sd15_shuffle.yaml,control_v11e_sd15_shuffle.yaml
#control_v11p_sd15_mlsd.yaml,control_v11p_sd15_mlsd.yaml
#control_v11p_sd15_normalbae.yaml,control_v11p_sd15_normalbae.yaml
#control_v11p_sd15_scribble.yaml,control_v11p_sd15_scribble.yaml
#control_v11p_sd15_seg.yaml,control_v11p_sd15_seg.yaml
#control_v11p_sd15_softedge.yaml,control_v11p_sd15_softedge.yaml
#control_v11p_sd15s2_lineart_anime.yaml,control_v11p_sd15s2_lineart_anime.yaml
check_and_download "$1" "controlnet_sd15" "$data" "ControlNet-v1-1-diff" "controlnet"

data="control_v1p_sd15_brightness.safetensors,control_v1p_sd15_brightness.safetensors"
#control_v1p_sd15_illumination.safetensors,control_v1p_sd15_illumination.safetensors
#controlnetQRPatternQR_v2Sd15.safetensors,controlnetQRPatternQR_v2Sd15.safetensors"
check_and_download "$1" "controlnet_sd15" "$data" "ControlNet-others" "controlnet"

#controlnet sdxl
data="
"
check_and_download "$1" "controlnet_sdxl" "$data" "ControlNet-SDXL" "controlnet"


data="InsPX.safetensors,InsPX.safetensors"
check_and_download "$1" "lycoris" "$data" "StableDiffusion-lycoris"


data="leres/res101.pth,res101.pth
leres/latest_net_G.pth,latest_net_G.pth
lineart_anime/netG.pth,netG.pth
lineart/sk_model.pth,sk_model.pth
lineart/sk_model2.pth,sk_model2.pth
midas/dpt_hybrid-midas-501f0c75.pt,dpt_hybrid-midas-501f0c75.pt
openpose/body_pose_model.pth,body_pose_model.pth
openpose/hand_pose_model.pth,hand_pose_model.pth
openpose/facenet.pth,facenet.pth
openpose/dw-ll_ucoco_384.onnx,dw-ll_ucoco_384.onnx
openpose/yolox_l.onnx,yolox_l.onnx
hed/ControlNetHED.pth,ControlNetHED.pth
zoedepth/ZoeD_M12_N.pt,ZoeD_M12_N.pt
manga_line/erika.pth,erika.pth
mlsd/mlsd_large_512_fp32.pth,mlsd_large_512_fp32.pth
normal_bae/scannet.pt,scannet.pt
pidinet/table5_pidinet.pth,table5_pidinet.pth
oneformer/250_16_swin_l_oneformer_ade20k_160k.pth,250_16_swin_l_oneformer_ade20k_160k.pth
oneformer/150_16_swin_l_oneformer_coco_100ep.pth,150_16_swin_l_oneformer_coco_100ep.pth
lama/ControlNetLama.pth,ControlNetLama.pth
uniformer/upernet_global_small.pth,upernet_global_small.pth"
check_and_download "$1" "controlnet_annotator" "$data" "StableDiffusion-others"
rm -r /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads
ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads


data="grounding-dino/GroundingDINO_SwinT_OGC.py,GroundingDINO_SwinT_OGC.py
grounding-dino/groundingdino_swint_ogc.pth,groundingdino_swint_ogc.pth
sam/sam_vit_h_4b8939.pth,sam_vit_h_4b8939.pth"
check_and_download "$1" "segment_anything" "$data" "StableDiffusion-others"
rm -r /root/stable-diffusion-webui/extensions/sd-webui-segment-anything/models
ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/sd-webui-segment-anything/models


data="AdaBins_nyu.pt,AdaBins_nyu.pt
dpt_large-midas-2f21e586.pt,dpt_large-midas-2f21e586.pt"
check_and_download "$1" "Deforum" "$data" "StableDiffusion-others"
rm -r /root/stable-diffusion-webui/models/Deforum
ln -s $model_dir/$1 /root/stable-diffusion-webui/models/Deforum


data="mapping_00109-model.pth.tar,mapping_00109-model.pth.tar
mapping_00229-model.pth.tar,mapping_00229-model.pth.tar
SadTalker_V0.0.2_256.safetensors,SadTalker_V0.0.2_256.safetensors
SadTalker_V0.0.2_512.safetensors,SadTalker_V0.0.2_512.safetensors"
check_and_download "$1" "SadTalker" "$data" "StableDiffusion-others"
rm -r /root/stable-diffusion-webui/extensions/SadTalker/checkpoints
ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/SadTalker/checkpoints


data="mm_sd_v15.ckpt,mm_sd_v15.ckpt"
check_and_download "$1" "AnimateDiff" "$data" "StableDiffusion-others"
rm -r /root/stable-diffusion-webui/extensions/sd-webui-animatediff/model
ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/sd-webui-animatediff/model


cache_backup_dir="/root/cache"
cache_dest_dir="/root/.cache"
if [ "$1" == "cache" ] && [ -d $cache_backup_dir ]; then
  mkdir -p $cache_dest_dir
  mv $cache_backup_dir/huggingface $cache_dest_dir/huggingface
  mv $cache_backup_dir/clip $cache_dest_dir/clip
  mv $cache_backup_dir/torch $cache_dest_dir/torch 2> /dev/null
  rm -r $cache_backup_dir

  echo -e ">>>> CLIP 和 tagger 模型搞定\n"
fi
