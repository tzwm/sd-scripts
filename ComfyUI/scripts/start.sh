#! /bin/bash

echo "启动中……"

mkdir -p /root/autodl-tmp/outputs

annotator_dir="/root/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts"
cd $annotator_dir
if [ -e "$annotator_dir/.tzwm_init" ]; then
  if [ -e '/root/autodl-tmp/models/lllyasviel_annotators' ]; then
    mkdir -p lllyasviel/Annotators
    mv /root/autodl-tmp/models/lllyasviel_annotators/* lllyasviel/Annotators/
    echo $(date +%s) > $annotator_dir/.tzwm_init
  fi
fi

cd /root/ComfyUI
source /root/tzwm-autodl/common/scripts/init-proxy.sh && \
python main.py --port 6006 --listen 0.0.0.0
