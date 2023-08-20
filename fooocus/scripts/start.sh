#! /bin/bash

echo "启动中……"

cd /root/Fooocus && source venv/bin/activate && python launch.py --port 6006
