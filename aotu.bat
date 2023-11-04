@echo off

set matchStr=443
:start
git add .
git commit -m "Auto commit"
git push origin master > output.txt
set /p str=<output.txt
echo %str% | findstr %matchStr% >nul && goto start || echo "push ok"
sleep 1800 # 每隔1小时自动提交一次

goto start