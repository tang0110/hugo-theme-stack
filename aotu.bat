@echo off

:start
git add .
git commit -m "Auto commit"
git push origin master

goto start