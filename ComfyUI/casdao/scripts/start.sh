#! /bin/bash

echo "启动中……"

source $HOME/tzwm-sd-scripts/ComfyUI/casdao/scripts/init_env.sh

mkdir -p $tzwm_data_dir/outputs

cd $HOME/ComfyUI

source $tzwm_scripts_dir/ComfyUI/casdao/scripts/init_proxy.sh && \
python main.py --port 4444 --listen 0.0.0.0
