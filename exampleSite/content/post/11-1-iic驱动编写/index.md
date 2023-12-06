+++
author = "Devin"
title = "iic驱动编写"
date = "2023-11-06"
description = "基于imx6ull的iic驱动编写"
categories = [
    "驱动编写"
]
tags = [
    "驱动开发","iic"
]

+++

![](1.jpg)

本次的任务是做一个数据采集，芯片是AP3216C三合一光传感器

有两个需要掌握I2C适配器驱动和I2C设备驱动

# 1.I2C适配器驱动

我们需要知道**i2c_adapter**结构体，步骤就是先初始化，然后注册

# 2.I2C设备驱动

i2c_client 表示I2C设备，由系统在设备树中解析出来并创建

i2c_driver 重点编写的对象

添加模块

```
insmod xxx.ok
```

删除模块

```
rmmod xxx.ok
```

查看驱动设备号

```
cat /proc/devices
```

