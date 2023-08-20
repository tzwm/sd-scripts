#! /bin/bash

echo "启动中，有点慢的，可能要等个半分钟……"

cd /root/Fooocus && source venv/bin/activate && python launch.py --port 6006
