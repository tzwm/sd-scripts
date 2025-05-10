init_files_path="/root/init_files"
target_path="/root/autodl-tmp/hugginface_cache/hub"

mkdir -p $target_path

mv $init_files_path/* $target_path/

echo '初始化模型文件完成...'
