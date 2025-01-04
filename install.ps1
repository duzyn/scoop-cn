# 需先以管理员权限打开系统自带的 Powershell，设置脚本运行权限
# Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser

# 如果有设 SCOOP 环境变量，就按环境变量来
$scoopDir = $env:SCOOP, "$env:USERPROFILE\scoop" | Where-Object { -not [String]::IsNullOrEmpty($_) } | Select-Object -First 1

# 设置 GitHub 代理地址
$githubProxy = "https://ghgo.xyz"

# 隐藏进度条
$global:ProgressPreference = 'SilentlyContinue'

# 安装 Scoop
(Invoke-RestMethod "$githubProxy/https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1").Replace("https://github.com", "$githubProxy/https://github.com")  | Invoke-Expression

# 将 Scoop 的仓库源替换为代理的
scoop config scoop_repo "$githubProxy/https://github.com/ScoopInstaller/Scoop"

# 目前没有安装 Git，所以先下载几个必需的软件的 JSON，组成一个临时的应用仓库
New-Item -ItemType Directory -Path "$scoopDir\buckets\scoop-cn\bucket", "$scoopDir\buckets\scoop-cn\scripts\7-zip", "$scoopDir\buckets\scoop-cn\scripts\git" | Out-Null

Write-Host "Downloading manifests of 7zip and git from scoop-cn bucket..."
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/7zip.json"                             -OutFile "$scoopDir\buckets\scoop-cn\bucket\7zip.json"
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/install-context.reg"            -OutFile "$scoopDir\buckets\scoop-cn\scripts\7-zip\install-context.reg"
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/uninstall-context.reg"          -OutFile "$scoopDir\buckets\scoop-cn\scripts\7-zip\uninstall-context.reg"
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/git.json"                              -OutFile "$scoopDir\buckets\scoop-cn\bucket\git.json"
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-context.reg"              -OutFile "$scoopDir\buckets\scoop-cn\scripts\git\install-context.reg"
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-context.reg"            -OutFile "$scoopDir\buckets\scoop-cn\scripts\git\uninstall-context.reg"
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-file-associations.reg"    -OutFile "$scoopDir\buckets\scoop-cn\scripts\git\install-file-associations.reg"
Invoke-RestMethod -Uri "$githubProxy/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-file-associations.reg"  -OutFile "$scoopDir\buckets\scoop-cn\scripts\git\uninstall-file-associations.reg"

# 安装时注意顺序是 7zip, git
scoop install scoop-cn/7zip
scoop install scoop-cn/git

# 将 Scoop 的 main 仓库源替换为代理的
Write-Host "Coverting main bucket to git repo..."
if (Test-Path -Path "$scoopDir\buckets\main") { scoop bucket rm main }

Write-Host "Adding main bucket from $githubProxy/https://github.com/ScoopInstaller/Main..."
scoop bucket add main "$githubProxy/https://github.com/ScoopInstaller/Main"

# scoop-cn 库还不是 Git 仓库，删掉后，重新添加 Git 仓库
Write-Host "Coverting scoop-cn bucket to git repo..."
if (Test-Path -Path "$scoopDir\buckets\scoop-cn") { scoop bucket rm scoop-cn }

Write-Host "Adding scoop-cn bucket from $githubProxy/https://github.com/duzyn/scoop-cn..."
scoop bucket add scoop-cn "$githubProxy/https://github.com/duzyn/scoop-cn"

Write-Host "Scoop and scoop-cn was installed successfully!"
