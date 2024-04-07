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
    (Get-Content $_.FullName) -replace '(github\.com/.+/releases/.*download)', 'mirror.ghproxy.com/https://$1' | Set-Content -Path $_.FullName

    # GitHub Archive
    (Get-Content $_.FullName) -replace '(github\.com/.+/archive/)', 'mirror.ghproxy.com/https://$1' | Set-Content -Path $_.FullName

    # GitHub Raw
    (Get-Content $_.FullName) -replace '(raw\.githubusercontent\.com)', 'mirror.ghproxy.com/https://$1' | Set-Content -Path $_.FullName
    (Get-Content $_.FullName) -replace '(github\.com/.+/raw/)', 'mirror.ghproxy.com/https://$1'          | Set-Content -Path $_.FullName

    # SourceForge
    # Use jaist
    (Get-Content $_.FullName) -replace '(//downloads\.sourceforge\.net/project/.+)(\")', '$1?use_mirror=jaist$2' | Set-Content -Path $_.FullName
    (Get-Content $_.FullName) -replace '(#/.+)(\?use_mirror=jaist)', '$2$1' | Set-Content -Path $_.FullName
    (Get-Content $_.FullName) -replace '(//sourceforge\.net/projects/.+/files/.+)(\")', '$1/download?use_mirror=jaist$2' | Set-Content -Path $_.FullName
    (Get-Content $_.FullName) -replace '(#/.+)(/download\?use_mirror=jaist)', '$2$1' | Set-Content -Path $_.FullName
    # Or use zenlayer

    # KDE Apps
    (Get-Content $_.FullName) -replace 'download\.kde\.org', 'mirrors.ustc.edu.cn/kde' | Set-Content -Path $_.FullName

    # 7-Zip
    (Get-Content $_.FullName) -replace 'www\.7-zip\.org/a', 'mirror.nju.edu.cn/7-zip' | Set-Content -Path $_.FullName

    # LaTeX, MiKTeX
    (Get-Content $_.FullName) -replace '(miktex\.org/download/ctan)|(mirrors.+/CTAN)', 'mirrors.aliyun.com/CTAN' | Set-Content -Path $_.FullName

    # Node
    (Get-Content $_.FullName) -replace 'nodejs\.org/dist', 'npmmirror.com/mirrors/node' | Set-Content -Path $_.FullName
    # Or
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
    (Get-Content $_.FullName) -replace 'download\.dbeaver\.com/community', 'mirror.ghproxy.com/https://github.com/dbeaver/dbeaver/releases/download' | Set-Content -Path $_.FullName
    # Or
    # (Get-Content $_.FullName) -replace 'download\.dbeaver\.com/community', 'mirrors.nju.edu.cn/github-release/dbeaver/dbeaver' | Set-Content -Path $_.FullName

    # OBS Studio
    (Get-Content $_.FullName) -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)\.zip', 'mirror.ghproxy.com/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1.zip' | Set-Content -Path $_.FullName
    # Or
    # (Get-Content $_.FullName) -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)\.zip', 'mirrors.nju.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20$1/OBS-Studio-$1.zip' | Set-Content -Path $_.FullName
    # (Get-Content $_.FullName) -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)\.zip', 'mirrors.tuna.tsinghua.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20$1/OBS-Studio-$1.zip' | Set-Content -Path $_.FullName

    # OBS Studio 2.7
    (Get-Content $_.FullName) -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'mirror.ghproxy.com/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Full' | Set-Content -Path $_.FullName

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
    (Get-Content $_.FullName) -replace 'files\.jkvinge\.net/packages/strawberry/StrawberrySetup-(.+)-mingw-x', 'mirror.ghproxy.com/https://github.com/strawberrymusicplayer/strawberry/releases/download/$1/StrawberrySetup-$1-mingw-x' | Set-Content -Path $_.FullName

    # SumatraPDF
    (Get-Content $_.FullName) -replace 'files\.sumatrapdfreader\.org/file/kjk-files/software/sumatrapdf/rel', 'www.sumatrapdfreader.org/dl/rel' | Set-Content -Path $_.FullName

    # Vim
    (Get-Content $_.FullName) -replace 'ftp\.nluug\.nl/pub/vim/pc', 'mirrors.ustc.edu.cn/vim/pc' | Set-Content -Path $_.FullName

    # Cygwin
    (Get-Content $_.FullName) -replace '//.*/cygwin/', '//mirrors.aliyun.com/cygwin/' | Set-Content -Path $_.FullName

    # Tor Browser, Tor
    # Or
    # https://tor.ybti.net/dist/
    # https://mirror.freedif.org/TorProject/dist
    # https://mirror.oldsql.cc/tor/dist/
    # https://tor.zilog.es/dist/
    # https://torproject.ph3x.at/dist/
    # https://www.eprci.com/tor/dist/
    # https://tor.calyxinstitute.org/dist/
    # https://torproject.mirror.metalgamer.eu/dist/
    # https://cyberside.net.ee/sibul/dist/
    (Get-Content $_.FullName) -replace 'archive\.torproject\.org/tor-package-archive', 'tor.ybti.net/dist' | Set-Content -Path $_.FullName

    # FastCopy
    (Get-Content $_.FullName) -replace 'fastcopy\.jp/archive', 'mirror.ghproxy.com/https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main' | Set-Content -Path $_.FullName

    # Scripts
    (Get-Content $_.FullName) -replace '(bucketsdir\\\\).+(\\\\scripts)', '$1scoop-cn$2' | Set-Content -Path $_.FullName

    # 将 depends 路径改为 scoop-cn
    (Get-Content $_.FullName) -replace '\"depends\":\s*\"(scoop\-cn/)?', '"depends": "scoop-cn/' | Set-Content -Path $_.FullName

    # 将 suggest 路径改为 scoop-cn
    (Get-Content $_.FullName) -creplace '\"main/|\"extras/|\"versions/|\"nirsoft/|\"sysinternals/|\"php/|\"nerd-fonts/|\"nonportable/|\"java/|\"games/', '"scoop-cn/' | Set-Content -Path $_.FullName
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
