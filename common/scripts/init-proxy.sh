#! /bin/bash

source /etc/network_turbo

echo 'git 科学加速启动'
git config --global http.proxy $http_proxy

if [ "$1" = "global" ]; then
  echo '开启全局加速'

  if pgrep clash > /dev/null
  then
    echo "clash is already running"
  else
    echo "starting clash"
    cd /root/clash

    if ! [ -e "config.yaml" ]; then
      cp /root/tzwm-autodl-sd-webui/common/configs/clash_config.yaml ./config.yaml
      server=$(echo $http_proxy | sed 's/http:\/\/\([^:]*\):.*/\1/')
      port=$(echo $http_proxy | sed 's/.*:\([0-9]*\)$/\1/')
      sed -i "s/server_address/$server/g" config.yaml
      sed -i "s/server_port/$port/g" config.yaml
    fi
    nohup ./clash -f config.yaml &
  fi

  export http_proxy=http://127.0.0.1:7890
  export https_proxy=http://127.0.0.1:7890
  #export no_proxy=localhost,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
fi
