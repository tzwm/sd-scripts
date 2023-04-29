#! /bin/bash

case $AutoDLRegion in
  #内蒙 A
  neimeng-A)
    proxy=http://192.168.1.174:12798
    ;;
  #北京 A
  beijing-B)
    proxy=http://100.72.64.19:12798
    ;;
  #芜湖区
  wuhu-A)
    proxy=http://192.168.0.91:12798
    ;;
  #西北A区
  west-A)
    proxy=http://192.168.1.174:12798
    ;;
  #毕业
  stu-A)
    proxy=http://10.0.0.7:12798
    ;;
  #宿迁企业区
  suqian-C)
    proxy=http://10.0.0.7:12798
    ;;
  *)
    echo "不知道你是哪个区的机器"
    exit 1
    ;;
esac

echo 'git 科学加速启动'
git config --global http.proxy $proxy
