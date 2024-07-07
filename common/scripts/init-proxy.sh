#! /bin/bash

source /etc/network_turbo

#git config --global http.proxy $http_proxy
#echo 'git 配置好了'

if [ "$1" = "global" ]; then
  echo '开启全局配置'

  if pgrep calm > /dev/null
  then
    echo "calm is already running"
  else
    echo "starting calm"
    cd /root/calm

    if ! [ -e "config.yaml" ]; then
      cp /root/tzwm-autodl-sd-webui/common/configs/calm_config.yaml ./config.yaml
      server=$(echo $http_proxy | sed 's/http:\/\/\([^:]*\):.*/\1/')
      port=$(echo $http_proxy | sed 's/.*:\([0-9]*\)$/\1/')
      sed -i "s/server_address/$server/g" config.yaml
      sed -i "s/server_port/$port/g" config.yaml
    fi
    nohup ./calm -f config.yaml &
  fi

  export http_proxy=http://127.0.0.1:7890
  export https_proxy=http://127.0.0.1:7890
  #export no_proxy=localhost,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
fi
