@echo off
git commit -a -m 'update'
git push --progress "origin" master:source
pause
REM >nul