#!/bin/bash
#########################################################
# Uncomment and change the variables below to your need:#
#########################################################

# Install directory without trailing slash
install_dir="/root"

# Name of the subdirectory
#clone_dir="stable-diffusion-webui"

# Commandline arguments for webui.py, for example: export COMMANDLINE_ARGS="--medvram --opt-split-attention"
export COMMANDLINE_ARGS="--port 6006 --enable-insecure-extension-access --api --xformers --opt-sdp-attention --no-half-vae --ckpt-dir /root/autodl-tmp/models/ckpt --embeddings-dir /root/autodl-tmp/models/embeddings --lora-dir /root/autodl-tmp/models/lora --vae-dir /root/autodl-tmp/models/vae --controlnet-dir /root/autodl-tmp/models/controlnet --lyco-dir /root/autodl-tmp/models/lycoris --skip-torch-cuda-test --skip-version-check --skip-python-version-check"

# python3 executable
#python_cmd="python3"

# git executable
#export GIT="git"

# python3 venv without trailing slash (defaults to ${install_dir}/${clone_dir}/venv)
#venv_dir="venv"

# script to launch to start the app
#export LAUNCH_SCRIPT="launch.py"

# install command for torch
#export TORCH_COMMAND="pip install torch==1.12.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113"

# Requirements file to use for stable-diffusion-webui
#export REQS_FILE="requirements_versions.txt"

# Fixed git repos
#export K_DIFFUSION_PACKAGE=""
#export GFPGAN_PACKAGE=""

# Fixed git commits
#export STABLE_DIFFUSION_COMMIT_HASH=""
#export TAMING_TRANSFORMERS_COMMIT_HASH=""
#export CODEFORMER_COMMIT_HASH=""
#export BLIP_COMMIT_HASH=""

# Uncomment to enable accelerated launch
# export ACCELERATE="True"

# Uncomment to disable TCMalloc
export NO_TCMALLOC="True"

###########################################
