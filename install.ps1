# 开启调试
# Set-PSDebug -Trace 1

# 需先以管理员权限打开系统自带的 Powershell，设置脚本运行权限
# Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser

if ($PSVersionTable.PSVersion.Major -lt 5) {
    # Windows 7 上的 Powershell 版本低于 5，需要先额外安装 WMF 5.1
    Write-Host "Powershell version should be greater than 5.1"
}
else {
    # 安装 Scoop
    (Invoke-RestMethod https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1).Replace('"https://github.com', '"https://ghproxy.com/https://github.com') | Invoke-Expression
}

# 将 Scoop 的仓库源替换为代理的
scoop config scoop_repo https://ghproxy.com/https://github.com/ScoopInstaller/Scoop

# 目前没有安装 Git，所以先下载几个必需的软件的 JSON，组成一个临时的应用仓库
New-Item -ItemType "directory" -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket"
New-Item -ItemType "directory" -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip"
New-Item -ItemType "directory" -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git"

Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/7zip.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\7zip.json"
Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\install-context.reg"
Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\uninstall-context.reg"

Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/git.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\git.json"
Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-context.reg"
Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-context.reg"
Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-file-associations.reg"
Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-file-associations.reg"

Invoke-RestMethod -Uri https://ghproxy.com/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/aria2.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\aria2.json"

# 安装时注意顺序是 7-Zip, Git, Aria2
scoop install scoop-cn/7zip
scoop install scoop-cn/git
scoop install scoop-cn/aria2

# 将 Scoop 的 main 仓库源替换为代理的
if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\main") {
    scoop bucket rm main
}
Write-Host "Adding main bucket..."
scoop bucket add main https://ghproxy.com/https://github.com/ScoopInstaller/Main

# scoop-cn 库还不是 Git 仓库，删掉后，重新添加 Git 仓库
if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\scoop-cn") {
    scoop bucket rm scoop-cn
}
Write-Host "Adding scoop-cn bucket..."
scoop bucket add scoop-cn https://ghproxy.com/https://github.com/duzyn/scoop-cn

Set-Location "$env:USERPROFILE\scoop\buckets\scoop-cn"
git config pull.rebase true

Write-Host "scoop and scoop-cn was installed successfully!"
