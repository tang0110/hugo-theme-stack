+++
author = "Devin"
title = "数通2024"
date = "2024-08-02"
description = "数通相关知识积累"
categories = [
    "数通知识"
]
tags = [
    "数通"
]

+++

![](1.jpg)



### 常用命令

#### `<system>`

```
dir		查看当前目录下的文件
cd		切换到目录文件
more	查看文件内容
show clock					查看系统时间
show process name 			查看进程信息
show current-configuration	查看设备所有端口的配置
show version				查看设备版本信息
show ip interface brief		查看设备ip管理
show ip routing-table		查看路由表
show interface Tunnel		查看隧道详细信息
```

#### `[system]`

```
show interface Tunnel brief						查看所有tunnel接口的配置(旧版本不行 1.2.0之前)
interface tunnel 199 mode v2v					创建一个199的tunnel接口并进入
interface loopback 100							进入loopback100配置,主要是ip地址的配置
ip address 1.1.1.1 255.255.255.0				在loopback下配置ip
ip address unnumbered interface LoopBack 100	将loopback100复用到端口上
ip route-static 1.1.1.2 32 Tunnel 0				静态路由设置
clock timezone BeiJing add 8:00:00				设置设备时区为北京时间东八时区
undo interface tunnel	123						删除物理接口下的隧道123
interface GigabitEthernet 0/0/0					设置具体某个端口参数
```

#### `v2v(en)`

```
show basic				查看基本信息
show tunnel				查看隧道信息
show version			查看软件版本信息
show vt status			查看mac/statuc/v2v number/单组播地址/vlan id
show running config		查看运行中的隧道，可以复制命令快速新增隧道
show manager_platform 0	查看管理平台

capture start			开始抓包(十几秒即可)
capture stop			停止抓包

单播
主叫配置
tunnel add 121 0 unicast 03:02:02:02:75:0c:02:00 caller yongchuan 121 00100002300010130006 121 noenc tunnel_if_number 121 ver v1
被叫配置
tunnel add 121 0 unicast 03:02:02:02:75:4c:04:00 called yongchan 121 00100002300023800003 121 noenc tunnel_if_number 121 ver v1

组播
主叫配置
tunnel add 121 0 multicast caller yongchuan 121 00100002300010130006 121 noenc tunnel_if_number 121 ver v1
被叫配置
tunnel add 121 0 multicast called yongchuan 121 00100002300023800003 121 noenc tunnel_if_number 121 ver v1

601B(主叫)
-------------------------------------------------------------------------------------------------------
| id|              mac|            status|          v2v number|           unicast addr|auto mac|vlan id|
-------------------------------------------------------------------------------------------------------
|  0|60:f2:ef:ee:04:9e|3 V2V online      |00100002300023800003|03:02:02:02:75:4c:04:00| DISable|      0|
-------------------------------------------------------------------------------------------------------

803B(被叫)
-------------------------------------------------------------------------------------------------------
| id|              mac|            status|          v2v number|           unicast addr|auto mac|vlan id|
-------------------------------------------------------------------------------------------------------
|  0|60:f2:ef:eb:00:4f|3 V2V online      |00100002300010130006|03:02:02:02:75:0c:02:00| DISable|      0|
-------------------------------------------------------------------------------------------------------
```

```
配置每个端口,如果要将路由器端口配置成交换口
show current-configuration
interface GigabitEthernet0 0/0/1
dis this
port link-mode bridge	桥接模式
port link-mode route	路由模式

v2v-port user	专用终端口
v2v-port net	视联网口

#
interface GigabitEthernet0/0/0
 port link-mode route
#
interface GigabitEthernet0/0/1
 port link-mode bridge
 port link-type trunk
 port trunk permit vlan all
 v2v-port user
#              
interface GigabitEthernet0/0/2
 port link-mode bridge
 port link-type trunk
 port trunk permit vlan all
 v2v-port user
#
interface GigabitEthernet0/0/6
 port link-mode bridge
 port link-type trunk
 port trunk permit vlan all
 v2v-port net
#
```







问题模板

```
问题：
设备：
提出人：
对接人：
时间：
信息：
分析步骤：
```



### 1.

```
问题：石柱设备在执行debug v2v packet时设备崩了，webcli远程不了了
设备：101B
提出人：刘玉东
对接人：汪惊奇
时间：8.1
信息：
	webcli通过v2v来通信的，报文量很多，导致打印太多造成
分析步骤：
	无
```

### 2.

```
问题：永川区设备组播隧道建立失败
设备：601B
提出人：刘玉东
对接人：汪惊奇
时间：8.1
信息：
	601B禁用再启用后重新入网，但是隧道没有起来，设备离线再上线，核心会清除原有状态，观察是否能建立起来
	993项目综管允许201，子号码范围是1-200，满足200个隧道的需要
	
	OC王克正建议用单播
	白天征建议通过综管修改路由器支持的子设备号数量
	组播也有本端和对端
	
	单播可以创建121编号的隧道，组播创建不了，需要了解单播和组播分别有那些编号不可使用
	单播和组播可以用同一个子号码
	
	现有的版本都推荐为单播(2024/8/5)(重庆项目)
	
分析步骤：
	1.禁用后在启用
	2.新创建一条199编号的隧道
	3.分析v2v.log日志，199隧道核心返回值为1，200返回为9
	4.核心修改子号码数量最大可为2000个(可在综管配置)，对应编号为0~1999，OC禁止使用0和1
```

```
admin
Visionvera123!@#,.
telnet 127.0.0.1 15000
```

### 3.

```
问题：被叫的本端子号码会自动更新为主叫的远端子号码
设备：601B/803B
提出人：刘玉东
对接人：汪惊奇
时间：8.1
信息：
	webcli通过v2v来通信的，报文量很多，导致打印太多造成
分析步骤：
	无
```

### Misc

```
组播和单播规定在一定范围内进行编号
例如:
组播:1~200
单播:201~Max

路由器每秒与核心同步时间,出现日志最新的时间没有,日志生成规则是在日志文件超过规定大小后删除旧信息

涪陵节点,101升级失败,运营商链路问题

核心服务器时间慢了2分钟

垫江	日志打印不行			10.46.41.254

永川  组播创建不行(东哥)		10.46.21.254

涪陵	组播创建也不行			10.46.28.254	x掉

8
监听端口超过100就奔溃了
debug信息太多会导致设备退网

路由器、数通、猫管、数据库、
2024/8/6	138

2024/8/7	141/143/144,其中141和143的问题关系不大

隧道创建失败,可能是隧道号、本端子号码、对端子号码冲突

snmp
```



