@echo off
title GIT上传脚本-yhgh
color 1E
call :showLogo


for /F %%i in ('git status ^| find /c ^"nothing to commit^, working tree clean^"') do ( set commitid=%%i)


set a=1
if %commitid% == 1 (
	echo ------------------------------------------------------------------------------
	echo                        文件没有变更，无需提交！！！
	echo ------------------------------------------------------------------------------
	pause
	exit
)

git add .
echo ------------------------------------------------------------------------------
set /p a=请输入更新信息：
echo ------------------------------------------------------------------------------
git commit -m "%date% %time% : %a%"
git push orgin master
echo ------------------------------------------------------------------------------
echo                             commit以及push成功！！！
echo ------------------------------------------------------------------------------
pause


:showLogo
if not exist .outlogo (
echo X19fX19fX19fICAgICAgICAgICAgICAgICAgICAgICAgLl9fICBfXyAgIF9fX18gX19fX19fX19fXyAgICAgICAgICAgICAuX18gICAgIApcXyAgIF9fXyBcICBfX19fICAgX19fX18gICBfX19fXyB8X198LyAgfF8vICBfIFxcX19fX19fICAgXF9fIF9fICBfX19fX3wgIHxfXyAgCi8gICAgXCAgXC8gLyAgXyBcIC8gICAgIFwgLyAgICAgXHwgIFwgICBfXz4gIF8gPC9cICAgICBfX18vICB8ICBcLyAgX19fLyAgfCAgXCAKXCAgICAgXF9fXyggIDxfPiApICBZIFkgIFwgIFkgWSAgXCAgfHwgIHwvICA8X1wgXC8gICAgfCAgIHwgIHwgIC9cX19fIFx8ICAgWSAgXAogXF9fX19fXyAgL1xfX19fL3xfX3xffCAgL19ffF98ICAvX198fF9ffFxfX19fX1wgXF9fX198ICAgfF9fX18vL19fX18gID5fX198ICAvCiAgICAgICAgXC8gICAgICAgICAgICAgXC8gICAgICBcLyAgICAgICAgICAgICAgIFwvICAgICAgICAgICAgICAgICAgIFwvICAgICBcLyAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAuX18gICAgICAgICAgICAuX18gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgX19fLl9fLnwgIHxfXyAgICBfX19fIHwgIHxfXyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgIDwgICB8ICB8fCAgfCAgXCAgLyBfX19cfCAgfCAgXCAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgIFxfX18gIHx8ICAgWSAgXC8gL18vICA+ICAgWSAgXCAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgLyBfX19ffHxfX198ICAvXF9fXyAgL3xfX198ICAvICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICBcLyAgICAgICAgICBcLy9fX19fXy8gICAgICBcLyAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiA=>.logo
certutil -decode .logo .outlogo>nul
del .logo
)
type .outlogo
goto :eof