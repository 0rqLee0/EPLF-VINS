#!/bin/bash

# 使用Docker容器运行RViz（带GPU支持）

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "启动RViz Docker容器..."

xhost +local:docker

docker run -it --rm \
    --name rviz-viewer \
    --net=host \
    --ipc=host \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --gpus all \
    -v "$PROJECT_DIR/config/vins_rviz_config.rviz":/root/vins_rviz_config.rviz:ro \
    ros:melodic-perception \
    bash -c "apt update && apt install -y ros-melodic-rviz > /dev/null 2>&1 && source /opt/ros/melodic/setup.bash && rviz -d /root/vins_rviz_config.rviz"
