#!/bin/bash

# 启动Docker容器运行EPLF-VINS
cd "$(dirname "$0")"

# 创建结果目录
mkdir -p ../result

echo "启动EPLF-VINS Docker容器..."
docker compose run eplf-vins

echo "Docker容器已退出"
