#! /bin/bash
#
sudo_prefix=""
if [ "$(whoami)" != "root"]; then
  sudo_prefix="sudo"
fi

$sudo_prefix apt-get update
$sudo_prefix apt-get install -y \
  libtalloc-dev gcc-c++ cmake \
  tmux tree git \
  aria2 ffmpeg yq

pip install --upgrade pip

pip install -U torch torchvision torchaudio \
  --extra-index-url https://download.pytorch.org/whl/cu121
python -c "import torch; print(torch.cuda.is_available())"

pip install -U xformers \
  --index-url https://download.pytorch.org/whl/cu121
