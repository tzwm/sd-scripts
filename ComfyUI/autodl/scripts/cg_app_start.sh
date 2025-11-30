#! /bin/bash

cd /root/tzwm-scripts
bash ComfyUI/autodl/scripts/init_comfyui.sh

python common/utils/downloader.py ComfyUI/autodl/configs/init_files_base.yaml
python common/utils/downloader.py ComfyUI/autodl/configs/init_files_z_image_turbo.yaml
python common/utils/downloader.py ComfyUI/autodl/configs/init_files_nunchaku_qwen_image.yaml
python common/utils/downloader.py ComfyUI/autodl/configs/init_files_wan.yaml

bash /root/tzwm-scripts/ComfyUI/autodl/scripts/start.sh
