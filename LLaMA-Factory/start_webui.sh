source /etc/network_turbo

cd /root/LLaMA-Factory
HF_HOME=/root/autodl-tmp/models GRADIO_SERVER_PORT=6006 llamafactory-cli webui
