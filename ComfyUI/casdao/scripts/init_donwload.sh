target_dir=$HOME/fssd/models
cache_dir=$HOME/fssd/huggingface

if [ -e $init_file ]; then
  echo -e "已经初始化过，跳过模型下载\n"
  exit
fi

init_file=$target_dir/.tzwm_init_download
HF_HUB_ENABLE_HF_TRANSFER=1 huggingface-cli download tzwm/sd-models --revision casdao --local-dir $target_dir --cache-dir $cache_dir --local-dir-use-symlinks False

echo $(date +%s) > $init_file

echo -e "初始化完毕\n"
