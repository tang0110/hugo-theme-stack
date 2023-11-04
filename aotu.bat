@echo off

:start
git add .
git commit -m "Auto commit"
git push origin master
echo "提交"
sleep 1800 # 每隔1小时自动提交一次

goto start