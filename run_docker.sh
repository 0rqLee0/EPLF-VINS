#!/bin/bash

# 启动Docker容器运行EPLF-VINS
cd /home/lee/EPLF-VINS

# 创建结果目录
mkdir -p /home/lee/EPLF-VINS/result

echo "启动EPLF-VINS Docker容器..."
docker compose run eplf-vins

echo "Docker容器已退出"