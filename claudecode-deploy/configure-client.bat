@echo off
chcp 65001 >nul
title ClaudeCode 文档访问配置工具

echo =========================================
echo    ClaudeCode 文档访问配置工具
echo =========================================
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限
    echo.
    echo 请按以下步骤操作：
    echo 1. 右键点击此文件
    echo 2. 选择"以管理员身份运行"
    echo.
    pause
    exit /b 1
)

:: ===== 配置区域 - 请修改为实际的服务器 IP =====
set SERVER_IP=192.168.1.100
:: ================================================

echo [信息] 服务器 IP: %SERVER_IP%
echo [信息] 域名: claudecode.com
echo.

:: 检查是否已配置
findstr /C:"%SERVER_IP%  claudecode.com" C:\Windows\System32\drivers\etc\hosts >nul 2>&1
if %errorLevel% equ 0 (
    echo [跳过] 已经配置过，无需重复配置
    goto :end
)

:: 检查是否有旧配置（不同 IP）
findstr /C:"claudecode.com" C:\Windows\System32\drivers\etc\hosts >nul 2>&1
if %errorLevel% equ 0 (
    echo [警告] 检测到 claudecode.com 已存在但 IP 不同
    echo.
    echo 当前 hosts 文件中的配置：
    findstr /C:"claudecode.com" C:\Windows\System32\drivers\etc\hosts
    echo.
    set /p REPLACE="是否替换为新的 IP？(Y/N): "
    if /i "%REPLACE%" neq "Y" (
        echo [取消] 已取消配置
        goto :end
    )

    :: 删除旧配置
    powershell -Command "(Get-Content C:\Windows\System32\drivers\etc\hosts) | Where-Object { $_ -notmatch 'claudecode.com' } | Set-Content C:\Windows\System32\drivers\etc\hosts"
    echo [完成] 已删除旧配置
)

:: 添加新配置
echo [进行中] 正在添加配置...
echo %SERVER_IP%  claudecode.com >> C:\Windows\System32\drivers\etc\hosts
if %errorLevel% neq 0 (
    echo [错误] 配置失败
    goto :end
)

echo [完成] 配置成功！
echo.

:end
echo.
echo =========================================
echo    配置完成
echo =========================================
echo.
echo 访问地址: http://claudecode.com
echo.
echo 提示：
echo - 如果无法访问，请检查：
echo   1. 服务器是否已部署
echo   2. 网络是否连通（ping %SERVER_IP%）
echo   3. 防火墙设置
echo.
pause
