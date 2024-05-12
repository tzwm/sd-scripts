#! /bin/bash

model_dir="/root/autodl-tmp/models"

sd_webui_dir="$HOME/stable-diffusion-webui"
comfyui_dir="$HOME/ComfyUI"

mkdir -p $model_dir
cd $model_dir

# model_type, data(dir, cg_name), cg_repo, [optional]target_dir
function cgdown() {
  local data=$2
  local target_dir="$1"
  if [ -n "$4" ]; then
    target_dir="$4"
  fi

  init_file="$target_dir/.tzwm_init_$1"
  if [ -e $init_file ]; then
    echo -e ">>>> $1 搞定\n"
    return
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

  if [ -e "$3" ]; then
    rm -r $3
  fi

  echo $(date +%s) > $init_file
  echo -e ">>>> $1 搞定\n"
}


if [ "$1" == "checkpoint_sd15" ]; then
  data="majicmixRealistic_v7.safetensors,majicmixRealistic_v7.safetensors"

  cgdown "$1" "$data" "StableDiffusion-checkpoints" "checkpoint"

  #fix old path
  if [ -d "$model_dir/ckpt" ] && [ ! -d "$model_dir/$1/ckpt" ]; then
    ln -s $model_dir/ckpt $model_dir/$1/ckpt
  fi
fi

if [ "$1" == "checkpoint_sdxl" ]; then
  data="juggernautXL_v9Rundiffusionphoto2.safetensors,juggernautXL_v9Rundiffusionphoto2.safetensors"

  cgdown "$1" "$data" "StableDiffusion-checkpoints" "checkpoint"

  #fix old path
  if [ -d "$model_dir/ckpt" ] && [ ! -d "$model_dir/$1/ckpt" ]; then
    ln -s $model_dir/ckpt $model_dir/$1/ckpt
  fi
fi

if [ "$1" == "vae" ]; then
  data="vae-ft-mse-840000-ema-pruned.safetensors,vae-ft-mse-840000-ema-pruned.safetensors
sdxl_vae_fp16_fix.safetensors,sdxl_vae_fp16_fix.safetensors"

  cgdown "$1" "$data" "StableDiffusion-VAE"
fi

if [ "$1" == "lora" ]; then
  data="sd15_lcm_lora_rank1.safetensors,sd15_lcm_lora_rank1.safetensors
sdxl_LCM_lora_rank1.safetensors,sdxl_LCM_lora_rank1.safetensors
sdxl_lightning_4step_lora.safetensors,sdxl_lightning_4step_lora.safetensors
sdxl_lightning_8step_lora.safetensors,sdxl_lightning_8step_lora.safetensors
Hyper-SDXL-8steps-CFG-lora.safetensors,Hyper-SDXL-8steps-CFG-lora.safetensors
Hyper-SD15-8steps-CFG-lora.safetensors,Hyper-SD15-8steps-CFG-lora.safetensors"

  cgdown "$1" "$data" "StableDiffusion-LoRAs"
fi

if [ "$1" == "embeddings" ]; then
  data="easy_negative.safetensors,easy_negative.safetensors"

  cgdown "$1" "$data" "StableDiffusion-Embeddings"
fi

#controlnet sd1.5 v1.1
if [ "$1" == "controlnet_sd15_v1_1_full" ]; then
  data="control_v11f1e_sd15_tile_fp16.safetensors,control_v11f1e_sd15_tile_fp16.safetensors
control_v11f1p_sd15_depth_fp16.safetensors,control_v11f1p_sd15_depth_fp16.safetensors
control_v11p_sd15_lineart_fp16.safetensors,control_v11p_sd15_lineart_fp16.safetensors
control_v11p_sd15_openpose_fp16.safetensors,control_v11p_sd15_openpose_fp16.safetensors
control_v11p_sd15_inpaint_fp16.safetensors,control_v11p_sd15_inpaint_fp16.safetensors
control_v11p_sd15_canny_fp16.safetensors,control_v11p_sd15_canny_fp16.safetensors
control_v11e_sd15_ip2p_fp16.safetensors,control_v11e_sd15_ip2p_fp16.safetensors
control_v11e_sd15_shuffle_fp16.safetensors,control_v11e_sd15_shuffle_fp16.safetensors
control_v11p_sd15_mlsd_fp16.safetensors,control_v11p_sd15_mlsd_fp16.safetensors
control_v11p_sd15_normalbae_fp16.safetensors,control_v11p_sd15_normalbae_fp16.safetensors
control_v11p_sd15_scribble_fp16.safetensors,control_v11p_sd15_scribble_fp16.safetensors
control_v11p_sd15_seg_fp16.safetensors,control_v11p_sd15_seg_fp16.safetensors
control_v11p_sd15_softedge_fp16.safetensors,control_v11p_sd15_softedge_fp16.safetensors
control_v11p_sd15s2_lineart_anime_fp16.safetensors,control_v11p_sd15s2_lineart_anime_fp16.safetensors
control_v11f1e_sd15_tile.yaml,control_v11f1e_sd15_tile.yaml
control_v11f1p_sd15_depth.yaml,control_v11f1p_sd15_depth.yaml
control_v11p_sd15_lineart.yaml,control_v11p_sd15_lineart.yaml
control_v11p_sd15_openpose.yaml,control_v11p_sd15_openpose.yaml
control_v11p_sd15_inpaint.yaml,control_v11p_sd15_inpaint.yaml
control_v11p_sd15_canny.yaml,control_v11p_sd15_canny.yaml
control_v11e_sd15_ip2p.yaml,control_v11e_sd15_ip2p.yaml
control_v11e_sd15_shuffle.yaml,control_v11e_sd15_shuffle.yaml
control_v11p_sd15_mlsd.yaml,control_v11p_sd15_mlsd.yaml
control_v11p_sd15_normalbae.yaml,control_v11p_sd15_normalbae.yaml
control_v11p_sd15_scribble.yaml,control_v11p_sd15_scribble.yaml
control_v11p_sd15_seg.yaml,control_v11p_sd15_seg.yaml
control_v11p_sd15_softedge.yaml,control_v11p_sd15_softedge.yaml
control_v11p_sd15s2_lineart_anime.yaml,control_v11p_sd15s2_lineart_anime.yaml"

  cgdown "$1" "$data" "ControlNet-v1-1-diff" "controlnet"
fi

if [ "$1" == "controlnet_sd15_v1_1_lite" ]; then
  data="control_v11f1e_sd15_tile_fp16.safetensors,control_v11f1e_sd15_tile_fp16.safetensors
control_v11f1p_sd15_depth_fp16.safetensors,control_v11f1p_sd15_depth_fp16.safetensors
control_v11p_sd15_lineart_fp16.safetensors,control_v11p_sd15_lineart_fp16.safetensors
control_v11p_sd15_openpose_fp16.safetensors,control_v11p_sd15_openpose_fp16.safetensors
control_v11p_sd15_inpaint_fp16.safetensors,control_v11p_sd15_inpaint_fp16.safetensors
control_v11p_sd15_seg_fp16.safetensors,control_v11p_sd15_seg_fp16.safetensors
control_v11p_sd15_canny_fp16.safetensors,control_v11p_sd15_canny_fp16.safetensors
control_v11p_sd15_softedge_fp16.safetensors,control_v11p_sd15_softedge_fp16.safetensors
control_v11f1e_sd15_tile.yaml,control_v11f1e_sd15_tile.yaml
control_v11f1p_sd15_depth.yaml,control_v11f1p_sd15_depth.yaml
control_v11p_sd15_lineart.yaml,control_v11p_sd15_lineart.yaml
control_v11p_sd15_openpose.yaml,control_v11p_sd15_openpose.yaml
control_v11p_sd15_inpaint.yaml,control_v11p_sd15_inpaint.yaml
control_v11p_sd15_seg.yaml,control_v11p_sd15_seg.yaml
control_v11p_sd15_softedge.yaml,control_v11p_sd15_softedge.yaml
control_v11p_sd15_canny.yaml,control_v11p_sd15_canny.yaml"
#control_v11e_sd15_ip2p_fp16.safetensors,control_v11e_sd15_ip2p_fp16.safetensors
#control_v11e_sd15_shuffle_fp16.safetensors,control_v11e_sd15_shuffle_fp16.safetensors
#control_v11p_sd15_mlsd_fp16.safetensors,control_v11p_sd15_mlsd_fp16.safetensors
#control_v11p_sd15_normalbae_fp16.safetensors,control_v11p_sd15_normalbae_fp16.safetensors
#control_v11p_sd15_scribble_fp16.safetensors,control_v11p_sd15_scribble_fp16.safetensors
#control_v11p_sd15s2_lineart_anime_fp16.safetensors,control_v11p_sd15s2_lineart_anime_fp16.safetensors
#control_v11e_sd15_ip2p.yaml,control_v11e_sd15_ip2p.yaml
#control_v11e_sd15_shuffle.yaml,control_v11e_sd15_shuffle.yaml
#control_v11p_sd15_mlsd.yaml,control_v11p_sd15_mlsd.yaml
#control_v11p_sd15_normalbae.yaml,control_v11p_sd15_normalbae.yaml
#control_v11p_sd15_scribble.yaml,control_v11p_sd15_scribble.yaml
#control_v11p_sd15s2_lineart_anime.yaml,control_v11p_sd15s2_lineart_anime.yaml

  cgdown "$1" "$data" "ControlNet-v1-1-diff" "controlnet"
fi

if [ "$1" == "controlnet_sd15_others" ]; then
  data="control_v1p_sd15_brightness.safetensors,control_v1p_sd15_brightness.safetensors"
#control_v1p_sd15_illumination.safetensors,control_v1p_sd15_illumination.safetensors
#controlnetQRPatternQR_v2Sd15.safetensors,controlnetQRPatternQR_v2Sd15.safetensors"

  cgdown "$1" "$data" "ControlNet-others" "controlnet"
fi

if [ "$1" == "controlnet_sd15_v1_1_400" ]; then
  data="ioclab_sd15_recolor.safetensors,ioclab_sd15_recolor.safetensors
ip-adapter_sd15.pth,ip-adapter_sd15.pth
ip-adapter_sd15_plus.pth,ip-adapter_sd15_plus.pth
ip-adapter-full-face_sd15.safetensors,ip-adapter-full-face_sd15.safetensors
ip-adapter-plus-face_sd15.safetensors,ip-adapter-plus-face_sd15.safetensors"

  cgdown "$1" "$data" "ControlNet-SDXL" "controlnet"
fi

#controlnet sdxl
if [ "$1" == "controlnet_sdxl" ]; then
  data="ttplanetSDXLControlnet_v20Fp16.safetensors,ttplanetSDXLControlnet_v20Fp16.safetensors
mistoLine_rank256.safetensors,mistoLine_rank256.safetensors"

  cgdown "$1" "$data" "ControlNet-SDXL" "controlnet"
fi

if [ "$1" == "lycoris" ]; then
  data="InsPX.safetensors,InsPX.safetensors"

  cgdown "$1" "$data" "StableDiffusion-lycoris"
fi

if [ "$1" == "controlnet_annotator" ]; then
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
lama/ControlNetLama.pth,ControlNetLama.pth
uniformer/upernet_global_small.pth,upernet_global_small.pth
clip_vision/clip_h.pth,clip_h.pth
insightface/models/antelopev2/1k3d68.onnx,1k3d68.onnx
insightface/models/antelopev2/2d106det.onnx,2d106det.onnx
insightface/models/antelopev2/genderage.onnx,genderage.onnx
insightface/models/antelopev2/glintr100.onnx,glintr100.onnx
insightface/models/antelopev2/scrfd_10g_bnkps.onnx,scrfd_10g_bnkps.onnx"
#oneformer/150_16_swin_l_oneformer_coco_100ep.pth,150_16_swin_l_oneformer_coco_100ep.pth
#clip_vision/clip_g.pth,clip_g.pth"
#clip_vision/clip_vitl.pth,clip_vitl.pth"

  cgdown "$1" "$data" "StableDiffusion-others"

  rm -r /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads
  ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads
fi

if [ "$1" == "segment_anything" ]; then
  data="grounding-dino/GroundingDINO_SwinT_OGC.py,GroundingDINO_SwinT_OGC.py
grounding-dino/groundingdino_swint_ogc.pth,groundingdino_swint_ogc.pth
sam/sam_vit_h_4b8939.pth,sam_vit_h_4b8939.pth"

  cgdown "$1" "$data" "StableDiffusion-others"

  if [ -e $sd_webui_dir ]; then
    rm -r $sd_webui_dir/extensions/sd-webui-segment-anything/models
    ln -s $model_dir/$1 $sd_webui_dir/extensions/sd-webui-segment-anything/models
  fi

#  if [ -e $comfyui_dir ]; then
    #rm -r $comfyui_dir/models/sam 2> /dev/null
    #ln -s $model_dir/$1/sam $comfyui_dir/models/sam
    #rm -r $comfyui_dir/models/grounding-dino 2> /dev/null
    #ln -s $model_dir/$1/grounding-dino $comfyui_dir/models/grounding-dino
  #fi
fi

if [ "$1" == "Deforum" ]; then
  data="AdaBins_nyu.pt,AdaBins_nyu.pt
dpt_large-midas-2f21e586.pt,dpt_large-midas-2f21e586.pt
film_interpolation/film_net_fp16.pt,film_net_fp16.pt"

  cgdown "$1" "$data" "StableDiffusion-others"

  rm -r /root/stable-diffusion-webui/models/Deforum
  ln -s $model_dir/$1 /root/stable-diffusion-webui/models/Deforum
fi

if [ "$1" == "SadTalker" ]; then
  data="mapping_00109-model.pth.tar,mapping_00109-model.pth.tar
mapping_00229-model.pth.tar,mapping_00229-model.pth.tar
SadTalker_V0.0.2_256.safetensors,SadTalker_V0.0.2_256.safetensors
SadTalker_V0.0.2_512.safetensors,SadTalker_V0.0.2_512.safetensors"

  cgdown "$1" "$data" "StableDiffusion-others"

  rm -r /root/stable-diffusion-webui/extensions/SadTalker/checkpoints
  ln -s $model_dir/$1 /root/stable-diffusion-webui/extensions/SadTalker/checkpoints
fi

if [ "$1" == "animatediff_model" ]; then
  data="mm_sd15_v2.safetensors,mm_sd15_v2.safetensors
mm_sd15_v3.safetensors,mm_sd15_v3.safetensors"

  cgdown "$1" "$data" "AnimateDiff-Models"

  webui_ext_dir="/root/stable-diffusion-webui/extensions/sd-webui-animatediff/model"
  if [ -d $webui_ext_dir ]; then
    rm -r $webui_ext_dir
    ln -s $model_dir/$1 $webui_ext_dir
  fi
fi

if [ "$1" == "animatediff_lora" ]; then
  data="v2_lora_PanLeft.ckpt,v2_lora_PanLeft.ckpt
v2_lora_PanRight.ckpt,v2_lora_PanRight.ckpt
v2_lora_RollingAnticlockwise.ckpt,v2_lora_RollingAnticlockwise.ckpt
v2_lora_RollingClockwise.ckpt,v2_lora_RollingClockwise.ckpt
v2_lora_TiltDown.ckpt,v2_lora_TiltDown.ckpt
v2_lora_TiltUp.ckpt,v2_lora_TiltUp.ckpt
v2_lora_ZoomIn.ckpt,v2_lora_ZoomIn.ckpt
v2_lora_ZoomOut.ckpt,v2_lora_ZoomOut.ckpt
v3_sd15_adapter.ckpt,v3_sd15_adapter.ckpt"

  cgdown "$1" "$data" "AnimateDiff-Models"

  animatediff_lora_target_path="$model_dir/lora/animatediff"
  if [ -d "$animatediff_lora_target_path" ]; then
    rm -r $animatediff_lora_target_path
    ln -s $model_dir/$1 $animatediff_lora_target_path
  fi
fi

if [ "$1" == "wav2lip" ]; then
  data="checkpoints/wav2lip.pth,wav2lip.pth
checkpoints/wav2lip_gan.pth,wav2lip_gan.pth
face_detection/detection/sfd/s3fd.pth,s3fd.pth
predicator/shape_predictor_68_face_landmarks.dat,shape_predictor_68_face_landmarks.dat"

  cgdown "$1" "$data" "StableDiffusion-others"
fi

if [ "$1" == "lllyasviel_annotators" ]; then
  data="150_16_swin_l_oneformer_coco_100ep.pth,150_16_swin_l_oneformer_coco_100ep.pth
250_16_swin_l_oneformer_ade20k_160k.pth,250_16_swin_l_oneformer_ade20k_160k.pth
ControlNetHED.pth,ControlNetHED.pth
ControlNetLama.pth,ControlNetLama.pth
RealESRGAN_x4plus.pth,RealESRGAN_x4plus.pth
ZoeD_M12_N.pt,ZoeD_M12_N.pt
body_pose_model.pth,body_pose_model.pth
clip_g.pth,clip_g.pth
dpt_hybrid-midas-501f0c75.pt,dpt_hybrid-midas-501f0c75.pt
erika.pth,erika.pth
facenet.pth,facenet.pth
hand_pose_model.pth,hand_pose_model.pth
lama.ckpt,lama.ckpt
latest_net_G.pth,latest_net_G.pth
mlsd_large_512_fp32.pth,mlsd_large_512_fp32.pth
netG.pth,netG.pth
network-bsds500.pth,network-bsds500.pth
res101.pth,res101.pth
scannet.pt,scannet.pt
sk_model.pth,sk_model.pth
sk_model2.pth,sk_model2.pth
table5_pidinet.pth,table5_pidinet.pth
upernet_global_small.pth,upernet_global_small.pth"

  cgdown "$1" "$data" "annotators"
fi

if [ "$1" == "svd" ]; then
  data="svd-fp16.safetensors,svd-fp16.safetensors"
#svd_xt-fp16.safetensors,svd_xt-fp16.safetensors
#svd.safetensors,svd.safetensors
#svd_xt.safetensors,svd_xt.safetensors"

  cgdown "$1" "$data" "stable-video-diffusion-img2vid" "checkpoint"
fi

if [ "$1" == "upscaler" ]; then
  data="RealESRGAN_x2plus.pth,RealESRGAN_x2plus.pth
RealESRGAN_x4plus.pth,RealESRGAN_x4plus.pth
RealESRGAN_x4plus_anime_6B.pth,RealESRGAN_x4plus_anime_6B.pth"

  cgdown "$1" "$data" "StableDiffusion-others"
fi

if [ "$1" == "ip_adapter" ]; then
  data="ip-adapter_sd15.safetensors,ip-adapter_sd15.safetensors
ip-adapter-plus_sd15.safetensors,ip-adapter-plus_sd15.safetensors
ip-adapter-plus-face_sd15.safetensors,ip-adapter-plus-face_sd15.safetensors
ip-adapter-plus_sdxl_vit-h.safetensors,ip-adapter-plus_sdxl_vit-h.safetensors
ip-adapter-plus-face_sdxl_vit-h.safetensors,ip-adapter-plus-face_sdxl_vit-h.safetensors
ip-adapter_pulid_sdxl_fp16.safetensors,ip-adapter_pulid_sdxl_fp16.safetensors"

  if [ -e $sd_webui_dir ]; then
    cgdown "$1" "$data" "IP-Adapter_tzwm" "controlnet"
  else
    cgdown "$1" "$data" "IP-Adapter_tzwm"
  fi
fi

if [ "$1" == "ip_adapter_faceid" ]; then
  data="models/ip-adapter-faceid-plusv2_sd15.bin,ip-adapter-faceid-plusv2_sd15.bin
models/ip-adapter-faceid-plusv2_sdxl.bin,ip-adapter-faceid-plusv2_sdxl.bin
models/ip-adapter-faceid-portrait_sd15.bin,ip-adapter-faceid-portrait_sd15.bin
lora/ip-adapter-faceid-plusv2_sd15_lora.safetensors,ip-adapter-faceid-plusv2_sd15_lora.safetensors
lora/ip-adapter-faceid-plusv2_sdxl_lora.safetensors,ip-adapter-faceid-plusv2_sdxl_lora.safetensors
lora/ip-adapter-faceid-plus_sd15_lora.safetensors,ip-adapter-faceid-plus_sd15_lora.safetensors
lora/ip-adapter-faceid_sd15_lora.safetensors,ip-adapter-faceid_sd15_lora.safetensors
lora/ip-adapter-faceid_sdxl_lora.safetensors,ip-adapter-faceid_sdxl_lora.safetensors"
#models/ip-adapter-faceid_sd15.bin,ip-adapter-faceid_sd15.bin
#models/imodels/ip-adapter-faceid-plus_sd15.bin,ip-adapter-faceid-plus_sd15.binp-adapter-faceid_sdxl.bin,ip-adapter-faceid_sdxl.bin

  cgdown "$1" "$data" "IP-Adapter-FaceID_tzwm"
fi

if [ "$1" == "ip_adapter_faceid_models" ]; then
  data="ip-adapter-faceid-plusv2_sd15.bin,ip-adapter-faceid-plusv2_sd15.bin
ip-adapter-faceid-plusv2_sdxl.bin,ip-adapter-faceid-plusv2_sdxl.bin
ip-adapter-faceid-portrait_sd15.bin,ip-adapter-faceid-portrait_sd15.bin"
#models/ip-adapter-faceid_sd15.bin,ip-adapter-faceid_sd15.bin
#models/imodels/ip-adapter-faceid-plus_sd15.bin,ip-adapter-faceid-plus_sd15.binp-adapter-faceid_sdxl.bin,ip-adapter-faceid_sdxl.bin

  cgdown "$1" "$data" "IP-Adapter-FaceID_tzwm" "controlnet"
fi

if [ "$1" == "ip_adapter_faceid_lora" ]; then
  data="ip-adapter-faceid-plusv2_sd15_lora.safetensors,ip-adapter-faceid-plusv2_sd15_lora.safetensors
ip-adapter-faceid-plusv2_sdxl_lora.safetensors,ip-adapter-faceid-plusv2_sdxl_lora.safetensors
ip-adapter-faceid-plus_sd15_lora.safetensors,ip-adapter-faceid-plus_sd15_lora.safetensors
ip-adapter-faceid_sd15_lora.safetensors,ip-adapter-faceid_sd15_lora.safetensors
ip-adapter-faceid_sdxl_lora.safetensors,ip-adapter-faceid_sdxl_lora.safetensors"

  cgdown "$1" "$data" "IP-Adapter-FaceID_tzwm" "lora"
fi

if [ "$1" == "clip_vision" ]; then
  data="clip_h.pth,clip_h.pth"
#clip_g.pth,clip_g.pth

  cgdown "$1" "$data" "StableDiffusion-others"
fi

if [ "$1" == "instantid" ]; then
  data="ip-adapter.bin,ip-adapter.bin"
  cgdown "$1" "$data" "ComfyUI_InstantID"

  data="instantid/diffusion_pytorch_model.safetensors,diffusion_pytorch_model.safetensors"
  cgdown "$1" "$data" "ComfyUI_InstantID" "controlnet"
fi

#if [ "$1" == "layerdiffusion" ]; then
  #data="layer_xl_bg2ble.safetensors,layer_xl_bg2ble.safetensors"
  #cgdown "$1" "$data" "tzwm/layerdiffusion"
#fi

cache_backup_dir="/root/cache"
cache_dest_dir="/root/.cache"
if [ "$1" == "cache" ] && [ -d $cache_backup_dir ]; then
  mkdir -p $cache_dest_dir
  mv $cache_backup_dir/huggingface $cache_dest_dir/huggingface
  mv $cache_backup_dir/clip $cache_dest_dir/clip 2> /dev/null
  mv $cache_backup_dir/torch $cache_dest_dir/torch 2> /dev/null
  rm -r $cache_backup_dir

  echo -e ">>>> CLIP 和 tagger 模型搞定\n"
fi
