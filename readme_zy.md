<!--
 * @FilePath: /undefined/home/zy/application/yolov4/WongKinYiu_PyTorch_YOLOv4/ScaledYOLOv4/readme_zy.md
 * @Description:
 * @Author: zy
 * @Date: 2021-03-04 17:16:33
 * @LastEditTime: 2021-03-05 16:10:26
 * @LastEditors: zy
-->


## References

1. https://github.com/DataXujing/ScaledYOLOv4
2. https://github.com/WongKinYiu/ScaledYOLOv4
3. https://github.com/WongKinYiu/ScaledYOLOv4/issues/125
4. https://github.com/AlexeyAB/darknet
5. https://github.com/AlexeyAB/darknet#pre-trained-models
6. https://github.com/linghu8812/tensorrt_inference/tree/master/ScaledYOLOv4
7. https://github.com/linghu8812/tensorrt_inference
8. https://github.com/AlexeyAB/darknet/wiki/YOLOv4-model-zoo
9. https://chocolatey.org/ THE PACKAGE MANAGER FOR WINDOWS Modern Software Automation




## Pre-trained models
There are weights-file for different cfg-files (trained for MS COCO dataset):

FPS on RTX 2070 (R) and Tesla V100 (V):

yolov4-csp.cfg - 202 MB: yolov4-csp.weights paper Scaled Yolo v4

just change width= and height= parameters in yolov4-csp.cfg file and use the same yolov4-csp.weights file for all cases:

width=640 height=640 in cfg: 66.2% mAP@0.5 (47.5% AP@0.5:0.95) - 70(V) FPS - 120 (60 FMA) BFlops
width=512 height=512 in cfg: 64.8% mAP@0.5 (46.2% AP@0.5:0.95) - 93(V) FPS - 77 (39 FMA) BFlops
pre-trained weights for training: https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-csp.conv.142


yolov4-csp.cfg

wget -c https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov4-csp.cfg


yolov4-csp.weights

wget -c https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-csp.weights


yolov4-csp.conv.142

wget -c https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-csp.conv.142



## 运行

**注意：**
1. 无特殊说明，默认情况下，以下命令在项目根目录下执行！

2. 打开新的 shell 终端时，要设置环境变量:
```bash
$ export LD_LIBRARY_PATH=/home/zy/anaconda3/lib:$LD_LIBRARY_PATH && export UMEXPR_MAX_THREADS=16
```

### training

COCO 数据集

```shell
$ python train.py --device 0 --batch-size 2 --data data/coco128.yaml --cfg models/yolov4-csp.cfg --weights weights/yolov4-csp.weights --name yolov4-csp
```

巨结肠数据集

```shell
$ python train.py --device 0 --batch-size 2 --data data/data_HD.yaml --cfg models/yolov4-csp.cfg --weights weights/yolov4-csp.weights --name yolov4-csp
```

### testing

yolov4-csp.weights

download yolov4-csp.weights and put it in /yolo/weights/ folder.

```shell
$ python test.py --img-size 640 --conf-thres 0.7 --batch-size 16 --device 0 --weights weights/yolov4-csp.weights --data data/coco128.yaml --cfg models/yolov4-csp.cfg
```

输出:

```
weights: weights/yolov4-csp.weights
Scanning labels /home/zy/application/yolov5/coco128/labels/train2017.cache (126 found, 0 missing, 2 empty, 0 duplicate, for 128 images): 100%|████████████████████████████████| 128/128 [00:00<00:00, 11630.90it/s]
               Class      Images     Targets           P           R      mAP@.5  mAP@.5:.95: 100%|██████████████████████████████████████████████████████████████████████████████████| 8/8 [00:06<00:00,  1.28it/s]
                 all         128         929       0.882       0.531       0.527       0.445
Speed: 36.8/1.2/38.0 ms inference/NMS/total per 640x640 image at batch-size 16
```



[Issues]

- ModuleNotFoundError: No module named 'mish_cuda'

```
(base) [zy@localhost ScaledYOLOv4]$ python test.py --img 640 --conf 0.001 --batch 8 --device 0 --data coco.yaml --cfg models/yolov4-csp.cfg
Traceback (most recent call last):
  File "test.py", line 13, in <module>
    from models.experimental import attempt_load
  File "/home/zy/application/yolov4/WongKinYiu_PyTorch_YOLOv4/ScaledYOLOv4/models/experimental.py", line 7, in <module>
    from models.common import Conv, DWConv
  File "/home/zy/application/yolov4/WongKinYiu_PyTorch_YOLOv4/ScaledYOLOv4/models/common.py", line 7, in <module>
    from mish_cuda import MishCuda as Mish
ModuleNotFoundError: No module named 'mish_cuda'
```


解决:

在项目同级目录下依次执行以下命令:

```shell
$ git clone https://github.com/thomasbrandon/mish-cuda
$ cd mish-cuda
$ python setup.py build install
```


- 下载 ninja

```
https://github.com/ninja-build/ninja/releases

$ wget -c https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip

解压
$ sudo unzip ninja-linux.zip -d /usr/local/bin/

软连接
$ sudo ln -s /usr/local/bin/ninja /usr/bin/ninja

测试是否成功
$ ninja --version
1.10.2
```


https://blog.csdn.net/qq_42189083/article/details/109612289

gcc: error: unrecognized command line option ‘-std=c++14’ 问题解决


http://ftp.gnu.org/gnu/gcc/gcc-5.5.0/