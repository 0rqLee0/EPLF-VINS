FROM ros:melodic-perception

# 避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础依赖
RUN apt-get update && apt-get install -y \
    cmake \
    git \
    libboost-all-dev \
    libeigen3-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    ros-melodic-cv-bridge \
    ros-melodic-tf \
    ros-melodic-message-filters \
    ros-melodic-image-transport \
    && rm -rf /var/lib/apt/lists/*

# 安装 Ceres Solver 1.14.0
WORKDIR /tmp
RUN git clone --branch 1.14.0 --depth 1 https://github.com/ceres-solver/ceres-solver.git && \
    cd ceres-solver && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/ceres-solver

# 安装 OpenCV 3.4.16 with contrib (EDLines需要)
WORKDIR /tmp
RUN git clone --branch 3.4.16 --depth 1 https://github.com/opencv/opencv.git && \
    git clone --branch 3.4.16 --depth 1 https://github.com/opencv/opencv_contrib.git && \
    cd opencv && mkdir build && cd build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DOPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DWITH_CUDA=OFF && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/opencv /tmp/opencv_contrib

# 创建catkin工作空间
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws

# 复制项目
COPY . /catkin_ws/src/EPLF-VINS

# 编译
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
    cd /catkin_ws && \
    catkin_make -DCMAKE_BUILD_TYPE=Release"

# 设置环境
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc && \
    echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc

WORKDIR /catkin_ws
CMD ["/bin/bash"]
