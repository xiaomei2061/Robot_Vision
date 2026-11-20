# 机甲杯 · 一键保存并上传
# 作用：把这次改动的代码存进本地 git 仓库，再上传到 GitHub。
# 你只需要双击同目录下的「保存并上传.bat」。

$ErrorActionPreference = 'Continue'

# ---- 1. 找到 git.exe ----
$git = 'D:\git\Git\cmd\git.exe'
if (-not (Test-Path -LiteralPath $git)) {
    $git = 'git'   # 如果 PATH 已经修好，直接用 git
}

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $repo

Write-Host ''
Write-Host '========== 保存并上传 ==========' -ForegroundColor Cyan
Write-Host "文件夹：$repo"
Write-Host ''

# ---- 2. 确认这里是 git 仓库 ----
& $git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host '这个文件夹还不是 git 仓库。' -ForegroundColor Red
    Write-Host '请先按 README.md 里「第一次设置」的内容初始化一次。'
    exit 1
}

# ---- 3. 把所有改动加入暂存区 ----
& $git add -A
if ($LASTEXITCODE -ne 0) {
    Write-Host 'git add 失败，请看上面的错误。' -ForegroundColor Red
    exit 1
}

# ---- 4. 有改动才提交 ----
$pending = & $git status --porcelain
if (-not $pending) {
    Write-Host '[1/2] 没有新的改动，跳过提交。' -ForegroundColor Yellow
} else {
    $changed = ($pending | Measure-Object).Count
    $msg = '保存：' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + "（$changed 个文件有改动）"
    & $git commit -q -m $msg
    if ($LASTEXITCODE -ne 0) {
        Write-Host '[1/2] 提交失败，请看上面的错误。' -ForegroundColor Red
        exit 1
    }
    Write-Host "[1/2] 已保存到本地（$changed 个文件）。" -ForegroundColor Green
}

# ---- 5. 检查有没有配置 GitHub 远程地址 ----
& $git remote get-url origin *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host ''
    Write-Host '[2/2] 还没设置 GitHub 远程仓库，所以这次只保存在了本地。' -ForegroundColor Yellow
    Write-Host '      按 README.md 里「第一次设置」第 3 步做一次，以后就能自动上传了。'
    exit 0
}

# ---- 6. 上传（第一次会自动建立跟踪关系） ----
$branch = (& $git rev-parse --abbrev-ref HEAD).Trim()
& $git rev-parse --abbrev-ref --symbolic-full-name '@{u}' *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[2/2] 第一次上传，正在把 $branch 分支连接到 GitHub……"
    & $git push -u origin $branch
} else {
    Write-Host '[2/2] 正在上传到 GitHub……'
    & $git push
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ''
    Write-Host '上传成功！代码已经在 GitHub 上了。' -ForegroundColor Green
} else {
    Write-Host ''
    Write-Host '上传失败。常见原因：' -ForegroundColor Red
    Write-Host '  1) 没登录 GitHub —— 见 README.md「常见问题」第 1 条'
    Write-Host '  2) 网络问题 —— 过一会儿再双击一次这个脚本'
    exit 1
}
