#! /bin/bash

sudo_prefix=""
if [ "$(whoami)" != "root" ]; then
  sudo_prefix="sudo"
fi

$sudo_prefix apt-get update
$sudo_prefix apt-get install -y \
  libtalloc-dev gcc g++ make cmake \
  iputils-ping tmux tree git wget \
  aria2 ffmpeg unzip vim htop \
  fonts-noto-cjk

pip install --upgrade pip

pip install pickleshare codewithgpu jupyterlab-language-pack-zh-CN huggingface_hub

# curl -fsSL https://ollama.com/install.sh | sh

# 安装google-chrome
wget -c "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install
rm -rf google-chrome-stable_current_amd64.deb
