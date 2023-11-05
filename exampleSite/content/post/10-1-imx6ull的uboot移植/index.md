+++
author = "Devin"
title = "imx6ull的uboot移植"
date = "2023-11-04"
description = "有关imx6ull开发板uboot移植"
categories = [
    "uboot移植"
]
tags = [
    "系统移植","U-boot"
]

+++

![](1.jpg)

# 烧写

```sh
./imxdownload u-boot.bin /dev/sdd		//sdd为需要写入的SD卡
```

# 设置board网络

```
setenv ipaddr 192.168.100.200
setenv ethaddr 00:0c:29:f9:9a:4b
setenv gatewayip 192.168.100.1
setenv netmask 255.255.255.0
setenv serverip 192.168.100.100
saveenv
```

# 根文件从nfs启动

```
1.Ubuntu配置
sudo apt-get install nfs-kernel-server

vim /etc/exports
/home/devin/imx6ull/nfs *(rw,sync,no_root_squash)

sudo /etc/init.d/nfs-kernel-server restart

2.board配置
setenv bootargs 'console=tty1 console=ttymxc0,115200 root=/dev/nfs nfsroot=192.168.100.100:/home/devin/imx6ull/nfs/rootfs,proto=tcp rw ip=192.168.100.200:192.168.100.100:192.168.100.1:255.255.255.0::eth0:off'

```

# kernel和devicetree从tftp启动

```
1.Ubuntu配置
sudo apt-get install tftp-server

sudo vim /etc/default/tftpd-hpa
内容如下:
# /etc/default/tftpd-hpa

--------------------------------------------

TFTP_USERNAME="tftp" #tftpd程序使用的账户

TFTP_DIRECTORY="/srv/tftp" #目录

TFTP_ADDRESS=":69" #端口

TFTP_OPTIONS="--secure --create"
--------------------------------------------------------
18.04ubuntu version

RPCNFSDCOUNT="-V 2 8"
RPCNFSDPRIORIYT=0
RPCMOUNTDOPTS="-V 2 --manage-gids"
NEED_SVCGSSD=""
RPCSVCGSSDOPTS="--nfs-version 2,3,4 --debug --syslog"

重启tftp
sudo service tftpd-hpa restart

2.board配置
setenv bootcmd 'tftp 80800000 zImage; tftp 83000000 imx6ull-alientek-emmc.dtb; bootz 80800000 - 83000000'
```

前面是已经获得uboot镜像后的操作，接下来就是从适配新板子一样去让uboot在imx6ull上跑起来，当然是从[github](https://github.com/u-boot/u-boot/tree/v2023.10)上获取原始的U-boot，再根据正点原子2016.03版本的uboot去更改原始的uboot即可

[相关流程可以参考](https://www.processon.com/v/YGkwDZ9q),代码实现可能随着版本不同有差异，这是uboot-2023.04的版本



# 获取仓库(2023.11.05)

```
git clone https://gitee.com/tangbo108/uboot-2023.10.git
```

# 1.修改Makefile文件

```
ARCH ?=arm
CROSS_COMPILE ?=arm-linux-gnueabihf-
```

如果已经下载好了交叉编译并且在环境变量中存在可像上面一样写，可以去/home目录更改.bashrc文件最后一行添加自己的交叉编译工具路径，也可以将上方的路径补全

[交叉编译工具链](https://www.linaro.org/downloads/)版本问题，当出现报错后根据提示更换适配版本即可

# 2.在board/freescale目录下创建特定板子的文件夹

```c
// 这里直接拷贝
cp mx6ullevk/ mx2310/ -r
目录文件如下
/* 专属于imx6ull开发板的配置，通过DCD段去使能芯片时钟以及系统初始化的寄存器配置 具体描述信息可参考doc/imx/mkimage/imximage.txt文件，通过mkimage工具可以生成专属于nxp imx6ull芯片的(systemclock+ddr)初始化代码 */
imximage.cfg
/* 编译指定板子，在config/xxx_defconfig下有指定的需要编译那一块开发板，比如这里定义的是TARGET_MX2310_14X14_EVK，然后会有SYS_BOARD/SYS_VENDOR/SYS_CONFIG_NAME/IMX_CONFIG去分别指定要编译的板子目录 板子厂商 板子配置的头文件也就是在include/config目录下 */
Kconfig
/* 主要维护人信息和维护文件 */
MAINTAINERS
/* 为了将该文件夹下的xxx.c文件通过递归的方式编译进去 */
Makefile
/* 特定芯片启动后执行的特定代码，包括ddr的大小设置 网络设置 串口设置等等早期初始化代码*/
mx2310.c
/* 作为插件或者脚本类型的ddr和时钟初始化汇编代码 */
plugin.S
```

# 3.修改mx2310目录下的内容

```

```



# 4.修改include/configs的目录下指定芯片配置头文件的内容

```

```



# 5.增加编译板子的Kconfig，图形配置

在arch/arm/mach-imx/mx6/Kconfig文件中，找到TARGET_MX6ULL_14X14_EVK定义，这是nxp的板子，这里我的定义是TARGET_MX2310_14X14_EVK，不同的厂商对应的目录不同，但都是在arch/arm/mach-xxx目录下的Kconfig文件

```
config TARGET_MX2310_14X14_EVK
	bool "Support mx6ull_14x14_evk"
	depends on MX6ULL
	select BOARD_LATE_INIT
	select DM
	select DM_THERMAL
	select IOMUX_LPSR
	imply CMD_DM
	
source "board/freescale/mx2310/Kconfig"
```

整体复制下来，只是将前面的定义改成我们自己的就行了，这样就可以使用**make menuconfig**进行图形配置了

不然就会出现如下错误，就是没有找到指定的头文件，然后生成的include/config.h出错

```
In file included from ./include/common.h:16:0:
include/config.h:3:22: fatal error: configs/.h: No such file or directory
 #include <configs/.h>
                      ^
compilation terminated.
In file included from ./include/common.h:16:0:
include/config.h:3:22: fatal error: configs/.h: No such file or directory
 #include <configs/.h>
```



# 6.适配板子上必要的外设

由于正点原子的开发板和NXP的evk标准板在SD/EMMC/串口等一些外设的引脚是一样，所以这些是不用更改的，但是LCD的引脚是一样，选型有差异，所以需要修改参数，网络是换了一种PYH芯片LAN8720A，所以需要重新再适配一下网络

## LCD驱动

```

```

## 网络驱动

```

```



***

分割线

***

对于U-boot2023.10版本，从编译开始看看系统到底发生了哪些变化

1.使用命令彻底清除一下工程

```
make distclean
```

2.使用命令去编译我们指定的板子，也就是上面的configs/mx2310_defconfig文件,并且生成一个.config文件，这里面是该板子是所有配置项参数，与你的芯片参数息息相关很重要

```
make mx2310_defconfig
```

3.使用命令去编译uboot获得uboot镜像文件

```
make -j12	// 这里的-j12代表使用12线程去同时编译，这样会比较快，但是前提是给Ubuntu分配有足够的处理器数量
```

