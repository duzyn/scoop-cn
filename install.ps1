# 隐藏进度条
$global:ProgressPreference = 'SilentlyContinue'

# --- Configuration ---
$GithubProxy = "https://gh-proxy.com"
$ScoopPath = if ($env:SCOOP) { $env:SCOOP } else { "$env:USERPROFILE\scoop" }
$ScoopMainRepo = "$GithubProxy/https://github.com/ScoopInstaller/Main.git"
$ScoopCNRepo = "$GithubProxy/https://github.com/duzyn/scoop-cn.git"

# --- Functions ---

function Set-ExecutionPolicyAndEnvironment {
    # 需先以管理员权限打开系统自带的 Powershell，设置脚本运行权限
    # Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser
    Write-Host "Set execution policy (requires manual step: Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser)"
    Write-Host "Setting environment variables..."
}

function Install-Scoop {
    Write-Host "Installing Scoop..."
    # gh-proxy.com 无需替换字符串，网站自动替换了
    Invoke-RestMethod "$GithubProxy/https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1" | Invoke-Expression

    Write-Host "Setting Scoop core repo to use proxy..."
    scoop config scoop_repo "$GithubProxy/https://github.com/ScoopInstaller/Scoop.git"
}

function Prepare-And-Install-Essentials {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    Write-Host "Temporarily modifying 7zip and git manifests for proxy download..."

    # 替换 7zip, git 的下载地址为代理的
    $7zipManifestPath = "$Path\buckets\main\bucket\7zip.json"
    $GitManifestPath = "$Path\buckets\main\bucket\git.json"

    if (Test-Path -Path $7zipManifestPath) {
        (Get-Content $7zipManifestPath) -replace 'https?://www\.7-zip\.org/a/7z(\d{2})(\d{2})', 'https://gh-proxy.com/https://github.com/ip7z/7zip/releases/download/$1.$2/7z$1$2' | Set-Content $7zipManifestPath
    }

    if (Test-Path -Path $GitManifestPath) {
        (Get-Content $GitManifestPath) -replace '(https?://github\.com/.+/releases/.*download)', 'https://gh-proxy.com/$1' | Set-Content $GitManifestPath
    }

    Write-Host "Installing essential apps (7zip, git)..."
    # 安装时注意顺序是 7zip, git
    scoop install 7zip
    scoop install git
}

function Setup-ScoopCN-Bucket {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    # 将 Scoop 的 main 仓库源替换为代理的
    if (Test-Path -Path "$Path\buckets\main") {
        Write-Host "Removing original main bucket..."
        scoop bucket rm main
    }

    Write-Host "Adding main bucket with proxy..."
    scoop bucket add main $ScoopMainRepo

    # 添加 scoop-cn 仓库
    Write-Host "Adding scoop-cn bucket..."
    scoop bucket add scoop-cn $ScoopCNRepo
}

function Migrate-Installed-Apps {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    Write-Host "Migrating 7zip, git to scoop-cn bucket..."
    # 将 7zip, git 转为后续用 scoop-cn 来更新
    Get-ChildItem -Path "$Path\apps" -Recurse -Filter "install.json" | ForEach-Object { 
        $content = Get-Content -Path $_.FullName -Raw
        # 仅替换 'main' bucket 到 'scoop-cn'
        if ($content -match '"bucket": "main"') {
            $content -replace '"bucket": "main"', '"bucket": "scoop-cn"' | Set-Content -Path $_.FullName 
        }
    }
}

# --- Main Execution ---

# Set-ExecutionPolicyAndEnvironment # 保持注释，提醒用户手动设置

Install-Scoop

Prepare-And-Install-Essentials -Path $ScoopPath

Setup-ScoopCN-Bucket -Path $ScoopPath

Migrate-Installed-Apps -Path $ScoopPath

Write-Host "scoop-cn was installed successfully!"
