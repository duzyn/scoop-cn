# 需先以管理员权限打开系统自带的 Powershell，设置脚本运行权限
# Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser

# 隐藏进度条
$global:ProgressPreference = 'SilentlyContinue'

# 设置 GitHub 代理地址
$GithubProxy = "https://ghproxy.cc"

# 如果有设 SCOOP 环境变量，就按环境变量来
$ScoopPath = if ($env:SCOOP) { $env:SCOOP } else { "$env:USERPROFILE\scoop" }

# 安装 Scoop
(Invoke-RestMethod "$GithubProxy/https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1").Replace("https://github.com", "$GithubProxy/https://github.com")  | Invoke-Expression

# 将 Scoop 的仓库源替换为代理的
scoop config scoop_repo "$GithubProxy/https://github.com/ScoopInstaller/Scoop"

# 替换 7zip, git 的下载地址为代理的
(Get-Content "$ScoopPath\buckets\main\bucket\7zip.json") -replace 'www\.7-zip\.org/a', 'mirrors.nju.edu.cn/7-zip' | Set-Content "$ScoopPath\buckets\main\bucket\7zip.json"
(Get-Content "$ScoopPath\buckets\main\bucket\git.json") -replace '(https?://github\.com/.+/releases/.*download)', 'https://ghproxy.cc/$1' | Set-Content "$ScoopPath\buckets\main\bucket\git.json"

# 安装时注意顺序是 7zip, git
scoop install 7zip
scoop install git

# 将 Scoop 的 main 仓库源替换为代理的
if (Test-Path -Path "$ScoopPath\buckets\main") { scoop bucket rm main }
scoop bucket add main "$GithubProxy/https://github.com/ScoopInstaller/Main"

# 添加 scoop-cn 仓库
scoop bucket add scoop-cn "$GithubProxy/https://github.com/duzyn/scoop-cn"

# 将 7zip 和 git 转为后续用 scoop-cn 来更新
Get-ChildItem -Path "$env:USERPROFILE\scoop\apps" -Recurse -Filter "install.json" | ForEach-Object { (Get-Content -Path $_.FullName -Raw) -replace '"bucket": "(main|extras|versions|nirsoft|sysinternals|php|nerd-fonts|nonportable|java|games)"', '"bucket": "scoop-cn"' | Set-Content -Path $_.FullName }

Write-Host "Scoop and scoop-cn was installed successfully!"
