#! /bin/bash

echo "启动中……"

source ./init.sh

mkdir -p $tzwm_data_dir/outputs

cd $HOME/ComfyUI

source $tzwm_scripts_dir/common/scripts/init-proxy.sh && \
python main.py --port 6006 --listen 0.0.0.0
