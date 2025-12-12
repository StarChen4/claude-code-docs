# ClaudeCode 文档构建和打包脚本
# 用途：在 Windows 上构建项目并打包为 zip 文件
# 使用：在 PowerShell 中运行 .\build-and-pack.ps1

Write-Host "==========================================" -ForegroundColor Green
Write-Host "   ClaudeCode 文档构建和打包工具" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# 检查 Node.js
Write-Host "[1/4] 检查 Node.js..." -ForegroundColor Green
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "错误：未找到 Node.js" -ForegroundColor Red
    Write-Host "请先安装 Node.js (https://nodejs.org/)" -ForegroundColor Yellow
    exit 1
}
$nodeVersion = node --version
Write-Host "✓ Node.js 版本: $nodeVersion" -ForegroundColor Green
Write-Host ""

# 检查依赖
Write-Host "[2/4] 检查项目依赖..." -ForegroundColor Green
if (-not (Test-Path "node_modules")) {
    Write-Host "依赖未安装，正在安装..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "错误：依赖安装失败" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✓ 依赖检查完成" -ForegroundColor Green
Write-Host ""

# 构建项目
Write-Host "[3/4] 构建生产版本..." -ForegroundColor Green
npm run docs:build
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误：构建失败" -ForegroundColor Red
    exit 1
}
Write-Host "✓ 构建成功" -ForegroundColor Green
Write-Host ""

# 打包文件
Write-Host "[4/4] 打包文件..." -ForegroundColor Green
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFileName = "claude-docs-$timestamp.zip"
$distPath = "docs\.vitepress\dist\*"

# 删除旧的 zip 文件（可选）
if (Test-Path "claude-docs-*.zip") {
    Write-Host "清理旧的 zip 文件..." -ForegroundColor Yellow
    Remove-Item "claude-docs-*.zip" -Force
}

# 创建新的 zip 文件
Compress-Archive -Path $distPath -DestinationPath $zipFileName -Force
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误：打包失败" -ForegroundColor Red
    exit 1
}

$zipSize = (Get-Item $zipFileName).Length / 1MB
Write-Host "✓ 打包完成" -ForegroundColor Green
Write-Host ""

Write-Host "==========================================" -ForegroundColor Green
Write-Host "   构建和打包完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "文件名称：" -ForegroundColor Cyan -NoNewline
Write-Host " $zipFileName"
Write-Host "文件大小：" -ForegroundColor Cyan -NoNewline
Write-Host " $([math]::Round($zipSize, 2)) MB"
Write-Host "文件位置：" -ForegroundColor Cyan -NoNewline
Write-Host " $(Get-Location)\$zipFileName"
Write-Host ""

Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "1. 将 $zipFileName 上传到 Linux 服务器的 /tmp/ 目录"
Write-Host "2. 将 deploy.sh 上传到服务器"
Write-Host "3. 在服务器上执行：sudo bash deploy.sh"
Write-Host ""

# 询问是否使用 scp 上传
Write-Host "是否现在使用 scp 上传到服务器？(Y/N)" -ForegroundColor Yellow -NoNewline
$upload = Read-Host " "

if ($upload -eq "Y" -or $upload -eq "y") {
    Write-Host ""
    $serverUser = Read-Host "请输入服务器用户名"
    $serverIP = Read-Host "请输入服务器 IP"

    Write-Host ""
    Write-Host "上传 $zipFileName ..." -ForegroundColor Green
    scp $zipFileName "${serverUser}@${serverIP}:/tmp/"

    Write-Host "上传 deploy.sh ..." -ForegroundColor Green
    scp deploy.sh "${serverUser}@${serverIP}:/tmp/"

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ 文件上传成功！" -ForegroundColor Green
        Write-Host ""
        Write-Host "接下来请在服务器上执行：" -ForegroundColor Yellow
        Write-Host "  ssh ${serverUser}@${serverIP}" -ForegroundColor Cyan
        Write-Host "  sudo bash /tmp/deploy.sh" -ForegroundColor Cyan
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "✗ 上传失败，请手动上传文件" -ForegroundColor Red
        Write-Host ""
    }
} else {
    Write-Host ""
    Write-Host "提示：使用 WinSCP 或 scp 命令上传文件" -ForegroundColor Yellow
    Write-Host "  scp $zipFileName user@服务器IP:/tmp/" -ForegroundColor Cyan
    Write-Host "  scp deploy.sh user@服务器IP:/tmp/" -ForegroundColor Cyan
    Write-Host ""
}
