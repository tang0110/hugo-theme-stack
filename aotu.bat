#!/bin/sh

while true
do
    git add .
    git commit -m "Auto commit"
    sleep 3600 # 每隔1小时自动提交一次
	git push origin master
done
