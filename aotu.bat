@echo off

set matchStr=443
:start
git add .
git commit -m "Auto commit"
git push origin master > output.txt
@REM set /p str=<output.txt
@REM echo %str% | findstr %matchStr% >nul && goto start || echo "push ok"
@REM sleep 10

goto start