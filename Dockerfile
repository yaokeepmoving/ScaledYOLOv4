# syntax = docker/dockerfile:experimental
#
# NOTE: To build this you will need a docker version > 18.06 with
#       experimental enabled and DOCKER_BUILDKIT=1
#
#       If you do not use buildkit you are not going to have a good time
#
#       For reference:
#           https://docs.docker.com/develop/develop-images/build_enhancements/


# ========== 概览 ==========

# 编译 caffe 环境

# [References]
# 1. https://github.com/docker-library/python/blob/master/3.7/stretch/Dockerfile
# 2. https://github.com/BVLC/caffe/blob/master/docker/gpu/Dockerfile
# 3. https://github.com/floydhub/dl-docker/blob/master/Dockerfile.gpu


# $ sudo docker pull nvidia/cuda:10.1-cudnn7-runtime-centos7
# sudo docker pull centos:centos7.9.2009
# $ sudo docker pull nvidia/cuda:10.1-cudnn7-devel-centos7
# ARG BASE_IMAGE=bvlc/caffe:gpu

ARG BASE_IMAGE=zy/pytorch:pytorch171cu101cudnn7

FROM ${BASE_IMAGE} as dev-base

LABEL maintainer.author.email="1132115539@qq.com"

# pip 国内源加速
# COPY ./common_utils/pip.conf /root/.pip/pip.conf

# cv2 依赖的库
RUN yum install -y libSM libXext


FROM dev-base as dev-deps

COPY ./whls /home/my_lib

RUN python3 -m pip install --upgrade pip wheel \
    && python3 -m pip install --no-index --find-links=/home/my_lib/ -r /home/my_lib/requirements.txt \
    && rm -rf /home/my_lib \
    && python3 -c "import torch;print(torch.__version__)"


FROM dev-base as dev

ARG APP_DIR=/home/scaled_yolov4

WORKDIR ${APP_DIR}

# 数据拷贝
COPY ./ScaledYOLOv4 ${APP_DIR}
COPY --from=dev-deps /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages

# 开启 GPU
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# 环境变量
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

CMD ["/bin/bash"]


# === 镜像、容器创建 ===

# 构建镜像:
# sudo docker build --network=host -t zy/scaled_yolov4:yolov4-csp-zy-v0.1.5 .

# 构建容器
# $ sudo docker run --name zy_scaled_yolov4_yolov4-csp-zy-v0.1.5 --network=host --gpus=all -v /home/zy/application/yolov5/coco128:/home/datasets/coco128 -it zy/scaled_yolov4:yolov4-csp-zy-v0.1.5 /bin/bash

# 导出镜像
# $ $ sudo docker save -o zy_scaled_yolov4_yolov4-csp-zy-v0.1.5_img.tar.gz zy/scaled_yolov4:yolov4-csp-zy-v0.1.5

# 导出容器
# sudo docker export -o xx.tar container_id
# sudo docker export -o zy_scaled_yolov4_yolov4-csp-zy-v0.1.5.tar f2deaa15729a

# 导入容器
# $ sudo docker import zy_scaled_yolov4_yolov4-csp-zy-v0.1.5.tar zy/scaled_yolov4:yolov4-csp-zy-v0.1.5

# $ sudo docker run --name zy_scaled_yolov4_yolov4-csp-zy-v0.1.5 --network=host --gpus=all -v $PWD/whls:/whls -it zy/scaled_yolov4:yolov4-csp-zy-v0.1.5 /bin/bash

# 导入镜像
# $ sudo docker load -i zy_python_py379centos7cuda101cudnn7v0.1.2.tar

# === 镜像、容器创建 ===