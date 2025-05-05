source /etc/network_turbo

mkdir -p /root/autodl-tmp/models
mkdir -p /root/autodl-tmp/hugginface_cache

cd /root/LLaMA-Factory
GRADIO_SERVER_PORT=6006 llamafactory-cli webui
