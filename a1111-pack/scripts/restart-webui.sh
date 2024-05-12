#! /bin/bash

mkdir -p /root/autodl-tmp/webui_outputs
mkdir -p /root/autodl-tmp/webui_outputs/SadTalker
mkdir -p /root/autodl-tmp/dreambooth
mkdir -p /root/autodl-tmp/TensorRT/Unet-onnx
mkdir -p /root/autodl-tmp/TensorRT/Unet-trt

echo "重启中，需要等待几秒……"

cd /root/stable-diffusion-webui/ && ./webui.sh -f --listen --port 6006 --enable-insecure-extension-access --api --xformers --opt-sdp-attention --no-half-vae --ckpt-dir /root/autodl-tmp/models/checkpoint --embeddings-dir /root/autodl-tmp/models/embeddings --lora-dir /root/autodl-tmp/models/lora --vae-dir /root/autodl-tmp/models/vae --controlnet-dir /root/autodl-tmp/models/controlnet --controlnet-annotator-models-path /root/autodl-tmp/models/controlnet_annotator --lyco-dir /root/autodl-tmp/models/lycoris --ad-no-huggingface --skip-torch-cuda-test --skip-version-check --skip-python-version-check
