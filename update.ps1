# 开启调试
# Set-PSDebug -Trace 1

# 删除已有的文件
Remove-Item -Path .\bucket  -Recurse -Force
Remove-Item -Path .\scripts -Recurse -Force

# 将克隆的最新的文件拷贝到待处理的文件夹
New-Item -ItemType "directory" -Path ".\bucket"
New-Item -ItemType "directory" -Path ".\scripts"

# Scoop 官方的十个库
Copy-Item -Path ".\Main\bucket\*"               -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Main\scripts\*"              -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Extras\bucket\*"             -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Extras\scripts\*"            -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Versions\bucket\*"           -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Versions\scripts\*"          -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Nonportable\bucket\*"        -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Nonportable\scripts\*"       -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Java\bucket\*"               -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\PHP\bucket\*"                -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-nirsoft\bucket\*"      -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-nerd-fonts\bucket\*"   -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-games\bucket\*"        -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-games\scripts\*"       -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\scoop-sysinternals\bucket\*" -Destination ".\bucket"  -Recurse -Force

# 复制完后，删掉克隆的文件夹
Remove-Item -Path .\Main               -Recurse -Force
Remove-Item -Path .\Extras             -Recurse -Force
Remove-Item -Path .\Versions           -Recurse -Force
Remove-Item -Path .\Nonportable        -Recurse -Force
Remove-Item -Path .\Java               -Recurse -Force
Remove-Item -Path .\PHP                -Recurse -Force
Remove-Item -Path .\scoop-nirsoft      -Recurse -Force
Remove-Item -Path .\scoop-nerd-fonts   -Recurse -Force
Remove-Item -Path .\scoop-games        -Recurse -Force
Remove-Item -Path .\scoop-sysinternals -Recurse -Force

Get-ChildItem -Recurse -Path .\bucket | ForEach-Object -Process {
    # GitHub Releases
    (Get-Content $_.FullName) -replace '(github\.com/.+/releases/download)', 'ghproxy.com/https://$1' | Set-Content -Path $_.FullName

    # GitHub Archive
    (Get-Content $_.FullName) -replace '(github\.com/.+/archive/)', 'ghproxy.com/https://$1' | Set-Content -Path $_.FullName

    # GitHub Raw
    (Get-Content $_.FullName) -replace '(raw\.githubusercontent\.com)', 'ghproxy.com/https://$1' | Set-Content -Path $_.FullName
    (Get-Content $_.FullName) -replace '(github\.com/.+/raw/)', 'ghproxy.com/https://$1'          | Set-Content -Path $_.FullName

    # SourceForge
    # (Get-Content $_.FullName) -replace 'downloads\.sourceforge\.net', 'nchc.dl.sourceforge.net' | Set-Content -Path $_.FullName

    # KDE Apps
    (Get-Content $_.FullName) -replace 'download\.kde\.org', 'mirrors.ustc.edu.cn/kde' | Set-Content -Path $_.FullName

    # 7-Zip
    (Get-Content $_.FullName) -replace 'www\.7-zip\.org/a', 'mirror.nju.edu.cn/7-zip' | Set-Content -Path $_.FullName

    # LaTeX, MiKTeX
    (Get-Content $_.FullName) -replace '(miktex\.org/download/ctan)|(mirrors.+/CTAN)', 'mirrors.aliyun.com/CTAN' | Set-Content -Path $_.FullName

    # Node
    (Get-Content $_.FullName) -replace 'nodejs\.org/dist', 'npmmirror.com/mirrors/node' | Set-Content -Path $_.FullName
    # 备用
    # (Get-Content $_.FullName) -replace 'nodejs\.org/dist', 'mirrors.aliyun.com/nodejs-release' | Set-Content -Path $_.FullName

    # Python
    (Get-Content $_.FullName) -replace 'www\.python\.org/ftp/python', 'npmmirror.com/mirrors/python' | Set-Content -Path $_.FullName

    # Go
    (Get-Content $_.FullName) -replace 'dl\.google\.com/go', 'mirrors.aliyun.com/golang' | Set-Content -Path $_.FullName

    # VLC
    (Get-Content $_.FullName) -replace 'download\.videolan\.org/pub', 'mirrors.aliyun.com/videolan' | Set-Content -Path $_.FullName

    # Inkscape
    (Get-Content $_.FullName) -replace 'media\.inkscape\.org/dl/resources/file', 'mirrors.nju.edu.cn/inkscape' | Set-Content -Path $_.FullName

    # DBeaver
    (Get-Content $_.FullName) -replace 'download\.dbeaver\.com/community', 'ghproxy.com/https://github.com/dbeaver/dbeaver/releases/download' | Set-Content -Path $_.FullName
    # 备用
    # (Get-Content $_.FullName) -replace 'download\.dbeaver\.com/community', 'mirrors.nju.edu.cn/github-release/dbeaver/dbeaver' | Set-Content -Path $_.FullName

    # OBS Studio
    (Get-Content $_.FullName) -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'mirrors.nju.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20$1/OBS-Studio-$1-Full' | Set-Content -Path $_.FullName
    # 备用
    # (Get-Content $_.FullName) -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'mirrors.tuna.tsinghua.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20$1/OBS-Studio-$1-Full' | Set-Content -Path $_.FullName

    # OBS Studio 2.7
    (Get-Content $_.FullName) -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'ghproxy.com/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Full' | Set-Content -Path $_.FullName

    # GIMP
    (Get-Content $_.FullName) -replace 'download\.gimp\.org/mirror/pub', 'mirrors.aliyun.com/gimp' | Set-Content -Path $_.FullName

    # Blender
    (Get-Content $_.FullName) -replace 'download\.blender\.org', 'mirrors.aliyun.com/blender' | Set-Content -Path $_.FullName

    # VirtualBox
    (Get-Content $_.FullName) -replace 'download\.virtualbox\.org/virtualbox', 'mirrors.nju.edu.cn/virtualbox' | Set-Content -Path $_.FullName

    # Wireshark
    # (Get-Content $_.FullName) -replace 'www\.wireshark\.org/download', 'mirrors.nju.edu.cn/wireshark' | Set-Content -Path $_.FullName

    # Lunacy
    (Get-Content $_.FullName) -replace 'lun-eu\.icons8\.com/s/', 'lcdn.icons8.com/' | Set-Content -Path $_.FullName

    # Strawberry
    (Get-Content $_.FullName) -replace 'files\.jkvinge\.net/packages/strawberry/StrawberrySetup-(.+)-mingw-x', 'ghproxy.com/https://github.com/strawberrymusicplayer/strawberry/releases/download/$1/StrawberrySetup-$1-mingw-x' | Set-Content -Path $_.FullName

    #SumatraPDF
    (Get-Content $_.FullName) -replace 'files\.sumatrapdfreader\.org/file/kjk-files/software/sumatrapdf/rel', 'www.sumatrapdfreader.org/dl/rel' | Set-Content -Path $_.FullName

    
    # Scripts
    (Get-Content $_.FullName) -replace '(bucketsdir\\\\).+(\\\\scripts)', '$1scoop-cn$2' | Set-Content -Path $_.FullName

    # 将 bucket 路径改为 scoop-cn
    # Select-String -Path .\bucket\*.* -Pattern '\"main/|\"extras/|\"versions/|\"nirsoft/|\"sysinternals/|\"php/|\"nerd-fonts/|\"nonportable/|\"java/|\"games/' -CaseSensitive
    (Get-Content $_.FullName) -replace '\"main/|\"extras/|\"versions/|\"nirsoft/|\"sysinternals/|\"php/|\"nerd-fonts/|\"nonportable/|\"java/|\"games/', '"scoop-cn/' | Set-Content -Path $_.FullName
}

# Start: Free Download Manager
(Get-Content .\bucket\freedownloadmanager.json).Replace('dn3.freedownloadmanager.org', 'files2.freedownloadmanager.org') | Set-Content -Path .\bucket\freedownloadmanager.json

$JSON = Get-Content .\bucket\freedownloadmanager.json | ConvertFrom-Json

Invoke-RestMethod $JSON.architecture."64bit".url -Outfile .\fdm_x64_setup.exe
Invoke-RestMethod $JSON.architecture."32bit".url -Outfile .\fdm_x86_setup.exe

$JSON.architecture."64bit".hash = (Get-FileHash .\fdm_x64_setup.exe -Algorithm SHA256).Hash.ToLower()
$JSON.architecture."32bit".hash = (Get-FileHash .\fdm_x86_setup.exe -Algorithm SHA256).Hash.ToLower()

$JSON | ConvertTo-Json -Depth 4 | Set-Content -Path .\bucket\freedownloadmanager.json

Remove-Item -Path .\fdm_x64_setup.exe
Remove-Item -Path .\fdm_x86_setup.exe
# End: Free Download Manager

# Start: Tor Browser
$JSON1                      = Invoke-RestMethod https://api.github.com/repos/TheTorProject/gettorbrowser/releases
$TOR_BROWSER_LATEST_VERSION = "$($JSON1.tag_name | Select-String -Pattern 'win64-.*')".Split("-")[1]
$TOR_BROWSER_64_URL         = $JSON1.assets.browser_download_url | Select-String -Pattern 'https://.+win64-.+_ALL\.exe$'
$TOR_BROWSER_32_URL         = $JSON1.assets.browser_download_url | Select-String -Pattern 'https://.+win32-.+_ALL\.exe$'

Invoke-RestMethod "$TOR_BROWSER_64_URL" -Outfile .\torbrowser-install-win64.exe
Invoke-RestMethod "$TOR_BROWSER_32_URL" -Outfile .\torbrowser-install-win32.exe

$TOR_BROWSER_64_URL = $TOR_BROWSER_64_URL -replace '(github\.com/.+/releases/download)', 'ghproxy.com/https://$1'
$TOR_BROWSER_32_URL = $TOR_BROWSER_32_URL -replace '(github\.com/.+/releases/download)', 'ghproxy.com/https://$1'

$JSON2                           = Get-Content .\bucket\tor-browser.json | ConvertFrom-Json
$JSON2.version                   = $TOR_BROWSER_LATEST_VERSION
$JSON2.architecture."64bit".url  = "$TOR_BROWSER_64_URL#/dl.7z"
$JSON2.architecture."32bit".url  = "$TOR_BROWSER_32_URL#/dl.7z"
$JSON2.architecture."64bit".hash = (Get-FileHash .\torbrowser-install-win64.exe -Algorithm SHA256).Hash.ToLower()
$JSON2.architecture."32bit".hash = (Get-FileHash .\torbrowser-install-win32.exe -Algorithm SHA256).Hash.ToLower()

$JSON2 | ConvertTo-Json -Depth 4 | Set-Content -Path .\bucket\tor-browser.json

(Get-Content .\bucket\tor-browser.json) -replace 'https://dist\.torproject\.org/torbrowser/\$version/torbrowser-install-win64-', 'https://ghproxy.com/https://github.com/TheTorProject/gettorbrowser/releases/download/win64-$version/torbrowser-install-win64-' | Set-Content -Path .\bucket\tor-browser.json
(Get-Content .\bucket\tor-browser.json) -replace 'https://dist\.torproject\.org/torbrowser/\$version/torbrowser-install-'      , 'https://ghproxy.com/https://github.com/TheTorProject/gettorbrowser/releases/download/win32-$version/torbrowser-install-'       | Set-Content -Path .\bucket\tor-browser.json

Remove-Item -Path .\torbrowser-install-win64.exe
Remove-Item -Path .\torbrowser-install-win32.exe
# End: Tor Browser
