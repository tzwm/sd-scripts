#! /bin/bash

sudo_prefix=""
if [ "$(whoami)" != "root" ]; then
  sudo_prefix="sudo"
fi

$sudo_prefix apt-get update
$sudo_prefix apt-get install -y \
  libtalloc-dev gcc g++ make cmake \
  iputils-ping tmux tree git wget \
  aria2 ffmpeg unzip vim htop

pip install --upgrade pip
