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

#### 烧写

```sh
./imxdownload u-boot.bin /dev/sdd		//sdd为需要写入的SD卡
```

```
Net:   eth1: ethernet@20b4000 [PRIME]Get shared mii bus on ethernet@2188000
Could not get PHY for FEC1: addr 0
```

