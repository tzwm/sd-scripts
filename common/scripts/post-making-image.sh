rm /root/clash/config.yaml

cache_backup_dir="/root/cache"
cache_dest_dir="/root/.cache"
mkdir -p $cache_backup_dir
mv $cache_dest_dir/huggingface $cache_backup_dir/huggingface
mv $cache_dest_dir/clip $cache_backup_dir/clip
rm -rf $cache_dest_dir
