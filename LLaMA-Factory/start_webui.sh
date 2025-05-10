source /etc/network_turbo

mkdir -p /root/autodl-tmp/hugginface_cache
mkdir -p /root/autodl-tmp/saves

echo '启动 webui 中...'

cd /root/LLaMA-Factory
GRADIO_SERVER_PORT=6006 llamafactory-cli webui
