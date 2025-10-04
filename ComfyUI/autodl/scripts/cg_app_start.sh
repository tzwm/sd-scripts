#! /bin/bash

cd /root/tzwm-scripts
bash ComfyUI/autodl/scripts/init_comfyui.sh

python common/utils/downloader.py ComfyUI/autodl/configs/init_files_base.yaml
python common/utils/downloader.py ComfyUI/autodl/configs/init_files_nunchaku_qwen_image_fp4.yaml

bash /root/tzwm-scripts/ComfyUI/autodl/scripts/start.sh
