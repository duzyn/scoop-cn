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
    $content = Get-Content $_.FullName

    # GitHub Releases
    $content = $content -replace '(github\.com/.+/releases/.*download)', 'ghgo.xyz/https://$1' 

    # GitHub Archive
    $content = $content -replace '(github\.com/.+/archive/)', 'ghgo.xyz/https://$1' 

    # GitHub Raw
    $content = $content -replace '(raw\.githubusercontent\.com)', 'ghgo.xyz/https://$1' 
    $content = $content -replace '(github\.com/.+/raw/)', 'ghgo.xyz/https://$1'          

    # KDE Apps
    $content = $content -replace 'download\.kde\.org', 'mirrors.nju.edu.cn/kde' 

    # 7-Zip
    $content = $content -replace 'www\.7-zip\.org/a', 'mirrors.nju.edu.cn/7-zip' 

    # LaTeX, MiKTeX
    $content = $content -replace '(miktex\.org/download/ctan)|(mirrors.+/CTAN)', 'mirrors.tuna.tsinghua.edu.cn/CTAN' 

    # Node
    $content = $content -replace 'nodejs\.org/dist', 'mirrors.tuna.tsinghua.edu.cn/nodejs-release' 
    
    # Python
    $content = $content -replace 'www\.python\.org/ftp/python', 'mirrors.nju.edu.cn/python' 

    # Go
    $content = $content -replace 'dl\.google\.com/go', 'mirrors.nju.edu.cn/golang' 

    # VLC
    $content = $content -replace 'download\.videolan\.org/pub', 'mirrors.tuna.tsinghua.edu.cn/videolan-ftp' 

    # Inkscape
    $content = $content -replace 'media\.inkscape\.org/dl/resources/file', 'mirrors.nju.edu.cn/inkscape' 

    # DBeaver
    # $content = $content -replace 'dbeaver\.io/files', 'ghgo.xyz/https://github.com/dbeaver/dbeaver/releases/download' 
    $content = $content -replace 'dbeaver\.io/files', 'mirrors.nju.edu.cn/github-release/dbeaver/dbeaver' 

    # OBS Studio
    # $content = $content -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Windows\.zip', 'ghgo.xyz/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Windows.zip' 
    $content = $content -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Windows\.zip', 'mirrors.tuna.tsinghua.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20$1/OBS-Studio-$1-Windows.zip' 

    # OBS Studio 2.7
    $content = $content -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'ghgo.xyz/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Full' 

    # GIMP
    $content = $content -replace 'download\.gimp\.org/mirror/pub', 'mirrors.nju.edu.cn/gimp' 

    # Blender
    $content = $content -replace 'download\.blender\.org', 'mirrors.tuna.tsinghua.edu.cn/blender' 

    # VirtualBox
    $content = $content -replace 'download\.virtualbox\.org/virtualbox', 'mirrors.tuna.tsinghua.edu.cn/virtualbox' 

    # Wireshark
    $content = $content -replace 'www\.wireshark\.org/download', 'mirrors.tuna.tsinghua.edu.cn/wireshark' 

    # Lunacy
    $content = $content -replace 'lun-eu\.icons8\.com/s/', 'lcdn.icons8.com/' 

    # Strawberry
    $content = $content -replace 'files\.jkvinge\.net/packages/strawberry/StrawberrySetup-(.+)-mingw-x', 'ghgo.xyz/https://github.com/strawberrymusicplayer/strawberry/releases/download/$1/StrawberrySetup-$1-mingw-x' 

    # Vim
    $content = $content -replace 'ftp\.nluug\.nl/pub/vim/pc', 'mirrors.nju.edu.cn/vim/pc' 

    # Cygwin
    $content = $content -replace '//.*/cygwin/', '//mirrors.tuna.tsinghua.edu.cn/cygwin/' 

    # Tor Browser, Tor
    $content = $content -replace 'archive\.torproject\.org/tor-package-archive', 'tor.calyxinstitute.org/dist' 

    # FastCopy
    $content = $content -replace 'fastcopy\.jp/archive', 'ghgo.xyz/https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main' 

    # Kodi
    $content = $content -replace 'mirrors\.kodi\.tv', 'mirrors.tuna.tsinghua.edu.cn/kodi' 

    # Typora
    $content = $content -replace 'download\.typora\.io', 'download2.typoraio.cn' 

		# Gradle
		$content = $content -replace 'services\.gradle\.org/distributions', 'mirror.nju.edu.cn/gradle' 

    # Scripts
    $content = $content -replace '(bucketsdir\\\\).+(\\\\scripts)', '$1scoop-cn$2' 

    # 将 suggest 路径改为 scoop-cn
    $content = $content -creplace '\"main/|\"extras/|\"versions/|\"nirsoft/|\"sysinternals/|\"php/|\"nerd-fonts/|\"nonportable/|\"java/|\"games/', '"scoop-cn/' 

    # 将 depends 路径改为 scoop-cn
    $content = $content -replace '\"depends\":\s*\"(scoop\-cn/)?', '"depends": "scoop-cn/' 
    Set-Content -Path $_.FullName -Value $content
}

