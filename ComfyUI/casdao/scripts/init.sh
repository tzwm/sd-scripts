source $(dirname $(realpath "$0"))/init_env.sh

d=$tzwm_scripts_dir/common/scripts

bash $d/init-download.sh checkpoint_sd15
#bash $d/common/scripts/init-download.sh checkpoint_sdxl
bash $d/common/scripts/init-download.sh vae
bash $d/common/scripts/init-download.sh lora
bash $d/common/scripts/init-download.sh embeddings
bash $d/common/scripts/init-download.sh controlnet_sd15_v1_1_lite
#bash $d/common/scripts/init-download.sh controlnet_sd15_others
#bash $d/common/scripts/init-download.sh controlnet_sd15_v1_1_400
#bash $d/common/scripts/init-download.sh controlnet_sdxl_v1_1_400
bash $d/common/scripts/init-download.sh animatediff_model
bash $d/common/scripts/init-download.sh animatediff_lora
bash $d/common/scripts/init-download.sh svd
bash $d/common/scripts/init-download.sh segment_anything
bash $d/common/scripts/init-download.sh upscaler
bash $d/common/scripts/init-download.sh ip_adapter
bash $d/common/scripts/init-download.sh ip_adapter_faceid
bash $d/common/scripts/init-download.sh clip_vision
