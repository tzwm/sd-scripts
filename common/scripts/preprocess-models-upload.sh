#!/bin/bash

dir="/root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads"
dir="/root/stable-diffusion-webui/extensions/sd-webui-segment-anything/models"

find "$dir" -type f -printf "%P,%f\n" | while read line; do
  echo "$line"
  path=$(echo "$line" | cut -d',' -f1)
  name=$(echo "$line" | cut -d',' -f2)

  #echo "$path"

  #cg upload "$dir/$path" --token gjuaNxsggKGSaHQM8D9_MaMR_Qc
done

#leres/res101.pth,res101.pth
#leres/latest_net_G.pth,latest_net_G.pth
#lineart_anime/netG.pth,netG.pth
#lineart/sk_model.pth,sk_model.pth
#lineart/sk_model2.pth,sk_model2.pth
#midas/dpt_hybrid-midas-501f0c75.pt,dpt_hybrid-midas-501f0c75.pt
#openpose/body_pose_model.pth,body_pose_model.pth
#openpose/hand_pose_model.pth,hand_pose_model.pth
#openpose/facenet.pth,facenet.pth
#hed/ControlNetHED.pth,ControlNetHED.pth
#zoedepth/ZoeD_M12_N.pt,ZoeD_M12_N.pt
#manga_line/erika.pth,erika.pth
#mlsd/mlsd_large_512_fp32.pth,mlsd_large_512_fp32.pth
#normal_bae/scannet.pt,scannet.pt
#pidinet/table5_pidinet.pth,table5_pidinet.pth
#oneformer/250_16_swin_l_oneformer_ade20k_160k.pth,250_16_swin_l_oneformer_ade20k_160k.pth
#oneformer/150_16_swin_l_oneformer_coco_100ep.pth,150_16_swin_l_oneformer_coco_100ep.pth


#grounding-dino/GroundingDINO_SwinT_OGC.py,GroundingDINO_SwinT_OGC.py
#grounding-dino/groundingdino_swint_ogc.pth,groundingdino_swint_ogc.pth
#sam/PUT_YOUR_SAM_MODEL_HERE.txt,PUT_YOUR_SAM_MODEL_HERE.txt
#sam/sam_vit_h_4b8939.pth,sam_vit_h_4b8939.pth
