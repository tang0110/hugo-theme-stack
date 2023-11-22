+++
author = "Devin"
title = "driver"
date = "2023-11-08"
description = "driver api guide"
categories = [
    "driver"
]
tags = [
    "driver"
]

+++

![](1.jpg)

# 1. 驱动模型

## 1.1 驱动绑定

**将设备和可以控制它的驱动程序绑定的过程，大多数的绑定过程可以用通用代码替代。**

### Bus

总线类型结构包含系统中该总线类型上的所有设备的列表。当device_register调用某个设备时，它被插入到该列表的末尾。总线对象还包含该总线类型的所有驱动程序的列表。当driver_register调用驱动程序时，它被插入到该列表的末尾。这是触发驱动程序绑定的两个事件。

### device_register

当添加新设备时，总线的驱动程序列表被迭代以找到支持它的驱动程序。为了确定，设备的设备ID必须与驱动程序支持的设备ID之一匹配。比较ID的格式和语义学是总线特定的。与其试图推导复杂的状态机和匹配算法，不如由总线驱动程序提供回调以将设备与驱动程序的ID进行比较。如果找到匹配项，总线返回1；否则返回0。

```c
int match(struct device * dev, struct device_driver * drv);
```

如果找到匹配项，设备的驱动程序字段将设置为驱动程序并调用驱动程序的探测回调。这使驱动程序有机会验证它是否确实支持硬件，并且它处于工作状态。

### Device Class

成功完成探测后，设备将注册到它所属的类。设备驱动程序属于一个且只有一个类，这是在驱动程序的devclass字段中设置的。调用devclass_add_device来枚举类中的设备，并将其实际注册到类中，这与类的register_dev回调一起发生。

### Driver

当驱动程序附加到设备时，该设备将插入到驱动程序的设备列表中。

### sysfs

在总线的“设备”目录中创建一个符号链接，该链接指向物理层次结构中的设备目录。

在驱动程序的“设备”目录中创建一个符号链接，该链接指向物理层次结构中的设备目录。

在类的目录中创建设备的目录。在该目录中创建一个符号链接，该链接指向设备在sysfs树中的物理位置。

可以在设备的物理目录中创建一个符号链接（尽管还没有这样做）到它的类目录或类的顶级目录。也可以创建一个来指向它的驱动程序目录。

### driver_register

添加新驱动程序时的过程几乎相同。迭代总线的设备列表以找到匹配项。跳过已经有驱动程序的设备。迭代所有设备，以将尽可能多的设备绑定到驱动程序。

### Removal

当一个设备被删除时，它的引用计数最终将变为0。当它这样做时，调用驱动程序的删除回调。它从驱动程序的设备列表中删除，驱动程序的引用计数递减。两者之间的所有符号链接都被删除。

删除驱动程序时，将遍历它支持的设备列表，并为每个设备调用驱动程序的删除回调。该设备将从该列表中删除，符号链接也将删除。

## 1.2 Bus Types

### Definition

 [`struct bus_type`](https://www.kernel.org/doc/html/latest/driver-api/infrastructure.html#c.bus_type)

int bus_register([`struct bus_type`](https://www.kernel.org/doc/html/latest/driver-api/infrastructure.html#c.bus_type) * bus);

### Declaration

内核中的总线类型应该声明一个该类型的静态对象，必须初始化名字字段，可以选择初始化回调

```c
struct bus_type pci_bus_type = {
       .name = "pci",
       .match        = pci_bus_match,
};
```

这个结构体应该导出到驱动的头文件

extern **struct bus_type** pci_bus_type;

### Registration



