+++
author = "Devin"
title = "开发工具——Git"
date = "2023-08-01"
description = "开发工具专题之Git"
categories = [
    "开发工具"
]
tags = [
    "开发工具","Git"
]
+++

![](1.jpg)

## Git学习记录

### 一、Git基本命令

#### 1. 设置用户名和邮箱

```gas
git config --global user.name "Devin"

git config --global user.email "Devin"
```

#### 2. 初始化和查看日志

```gas
git init
git log
```

#### 3. 添加文件和提交文件

```gas
git add test.txt    // 表示文件放到暂存区
git commit -m "注释" test.txt   // -m 表注释
```

#### 4. 查看工作区和暂存区状态

```gas
git status
```

#### 5.删除文件

```gas
rm test.txt
git add test.txt
git commit -m "删除test.txt" test.txt
```

### 二、Git分支命令

#### 1. 查看、创建、切换分支

```gas
git branch branch01  // 创建分支
git branch -v  // 查看分支
git branch branch01 //  切换分支
```

### 三、GitHub相关

#### 1. 为URL起别名以及查看别名

```gas
git remote add origin [url]
git remote -v
```

#### 2. 推送操作和克隆操作

```gas
git push [url] master  // master表示要推送的分支
git clone [url]
```

#### 3. 远程库修改的拉取

```gas
git pull [url] master
```

### 四、IDEA使用Git



### 五、实例

```gas
git remote add cs_notes https://github.com/CyC2018/CS-Notes.git  // 起别名
git pull cs_notes master  // 拉项目
git add .  // 添加到暂存区
git commit -m "modify test"  // 提交给git管理
git push cs_notes master  // 提交到GitHub
```



### 六、记录

```bash
查看配置信息
git config --list
每个配置的文件
git config --list --show-origin

增加远程仓库
git remote add origin <remote-url>
git remote set-url origin <remote-url>

个人信息配置(全局)
git config --global user.name "your-username"
git config --global user.email "your-email-address"

/*********************************** tag *************************************/
查看本地tag
git tag

添加本地tag
git tag tagname

删除本地tag
git tag -d tagname

推送本地tag
git push origin [tagname]	//推送单个tag
git push --tags	//推送本地所有tag

删除远程tag
git push --delete origin tagname

/****************************************	更改分支名称	****************************************/
git branch -m "原分支名" "新分支名"

如果是当前，那么可以使用加上新名字
git branch -m "新分支名称"

/**************************************************************************************************/
git reset HEAD <filename>			// 将文件从暂存区撤销
git reset HEAD~1					// 取消一次本地commit
git rm --cached filename			// 删除文件，并保留在本地。（取消跟踪文件）
git rm -r --cached dir				// 删除dir目录，并保留在本地。

/****************************************	合并分支	****************************************/
将mypid分支合并到master主分支
git checkout master					// 切换到主分支
git pull origin master				// 多人开发需要先拉取代码
git merge mypid						// 将mypid分支合并到master
git status							// 查看状态及执行提交命令
git push origin master				// 提交新的修改
/**************************************************************************************************/
git remote update origin --prune	// 更新远程分支列表
git branch -a						// 查看所有分支
git push origin --delete mypid		// 删除远程分支mypid
git branch -d  mypid				// 删除本地分支 mypid
/**************************************************************************************************/
git checkout -b name				// 新建一个分支，并切换到该分支
git push -u origin name1:name2		// 第一次将本地分支(左)推送到远程仓库(origin)的(右)远程分支
/**************************************************************************************************/
git checkout -- firename			// 执行了git rm firename 想退回
/**************************************************************************************************/
git reset --hard <提交commit号>	  // 退回到指定版本
/**************************************************************************************************/
将分支a合并到分支b
git checkout origin/a
git merge origin/b
```

