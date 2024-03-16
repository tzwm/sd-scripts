#!/bin/bash

comfyui_dir="~/ComfyUI"

git clone --depth 1 https://github.com/comfyanonymous/ComfyUI $comfyui_dir

cd $comfyui_dir
pip install -r requirements.txt
