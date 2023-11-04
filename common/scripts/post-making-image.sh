rm /root/calm/config.yaml

cache_backup_dir="/root/cache"
cache_dest_dir="/root/.cache"
mkdir -p $cache_backup_dir
mv $cache_dest_dir/huggingface $cache_backup_dir/huggingface
mv $cache_dest_dir/clip $cache_backup_dir/clip
mv $cache_dest_dir/torch $cache_backup_dir/torch 2> /dev/null
rm -rf $cache_dest_dir
