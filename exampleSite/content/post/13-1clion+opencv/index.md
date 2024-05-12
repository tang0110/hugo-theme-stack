+++
author = "Devin"
title = "clion"
date = "2024-4-12"
description = "clion"
categories = [
    "clion"
]
tags = [
    "clion"
]

+++

![](1.jpg)

1.下载opencv
https://opencv.org/get-started/ #一种是从源码构建,一种是已经构建的

2.下载cmake
https://cmake.org/download/

3.
(1) 打开cmake/bin/cmake-gui.exe
(2) source code 选择opencv\sources
(3) build the binaries 选择 opencv\mingw-build	// mingw-build目录为用户创建
(4) 点击 Configure
	可能出错ffmpeg相关包无法下载,需要手动下载
	(Ⅰ) opencv_videoio_ffmpeg.dll
	(Ⅱ) opencv_videoio_ffmpeg_64.dll
	(Ⅲ) ffmpeg_version.cmake
	将这三个文件放到opencv\sources\3rdparty\ffmpeg目录下面
	(Ⅳ)修改opencv\sources\3rdparty\ffmpeg目录下ffmpeg.cmake文件下载相关的内容
	/******************** #号部分为需要注释的内容 *******************************/
	 

```cmake
 set(status TRUE)
	  #foreach(id ${ids})
		#ocv_download(FILENAME ${name_${id}}
				   #HASH ${FFMPEG_FILE_HASH_${id}}
				   #URL
					 #"$ENV{OPENCV_FFMPEG_URL}"
					 #"${OPENCV_FFMPEG_URL}"
					 #"https://raw.githubusercontent.com/opencv/opencv_3rdparty/${FFMPEG_BINARIES_COMMIT}/ffmpeg/"
				   #DESTINATION_DIR ${FFMPEG_DOWNLOAD_DIR}
				   #ID FFMPEG
				   #RELATIVE_URL
				   #STATUS res)
		#if(NOT res)
			#set(status FALSE)
		#endif()
	  #endforeach()
	  if(status)
```

​	/******************** #号部分为需要注释的内容 *******************************/
(5) 点击 Generate
(6) 进入 opencv\mingw-build目录并打开Git Bash
(7) 将opencv\sources\3rdparty\ffmpeg目录复制到opencv\mingw-build\3rdparty目录
(8) 执行命令 mingw32-make -j8      #8代表处理器数量,多线程编译,加快速度
(9) 执行命令 mingw32-make install
(10)添加两个环境变量mingw-build\install\x64\mingw\bin mingw-build\bin

CMakeList.txt
/******************************************************/

```cmake
cmake_minimum_required(VERSION 3.15)
project(xxx)

set(CMAKE_CXX_STANDARD 14)

#设置opencv路径,也可以添加到环境变量

set(OpenCV_DIR "./.../mingw-build/install")
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})
add_executable(xxx main.cpp)

target_link_libraries(xxx ${OpenCV_LIBS})
```


/******************************************************/

遇到的问题
1.编译后程序奔溃,检查clion关于gcc的配置,这个配置和cmake时编译的要一致
