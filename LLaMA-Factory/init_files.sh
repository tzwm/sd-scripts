init_files_path="/root/init_files"
target_path="/root/autodl-tmp/hugginface_cache/hub"

mkdir -p $target_path

if [ -d $init_files_path ]; then
  mv "$init_files_path/*" "$target_path/"
  rm -r $init_files_path
end

echo '初始化模型文件完成...'
