# 删除已有的文件
Remove-Item -Path .\bucket  -Recurse -Force
Remove-Item -Path .\scripts -Recurse -Force

# 将克隆的最新的文件拷贝到待处理的文件夹
New-Item -ItemType Directory -Path .\bucket
New-Item -ItemType Directory -Path .\scripts

# Scoop 官方的十个库
Copy-Item -Path .\Main\bucket\*               -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\Extras\bucket\*             -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\Versions\bucket\*           -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\Nonportable\bucket\*        -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\Java\bucket\*               -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\PHP\bucket\*                -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\scoop-nirsoft\bucket\*      -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\scoop-nerd-fonts\bucket\*   -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\scoop-games\bucket\*        -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\scoop-sysinternals\bucket\* -Destination .\bucket  -Recurse -Force
Copy-Item -Path .\Main\scripts\*              -Destination .\scripts -Recurse -Force
Copy-Item -Path .\Extras\scripts\*            -Destination .\scripts -Recurse -Force
Copy-Item -Path .\Versions\scripts\*          -Destination .\scripts -Recurse -Force
Copy-Item -Path .\Nonportable\scripts\*       -Destination .\scripts -Recurse -Force
Copy-Item -Path .\scoop-games\scripts\*       -Destination .\scripts -Recurse -Force

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
    $content = $content -replace '(https?://github\.com/.+/releases/.*download)', 'https://ghproxy.cc/$1'

    # GitHub Archive
    $content = $content -replace '(https?://github\.com/.+/archive/)', 'https://ghproxy.cc/$1'

    # GitHub Gists
    $content = $content -replace '(https?://gist.github\.com/.+/)', 'https://ghproxy.cc/$1'

    # GitHub Raw
    $content = $content -replace '(https?://raw\.githubusercontent\.com)', 'https://ghproxy.cc/$1'
    $content = $content -replace '(https?://github\.com/.+/raw/)', 'https://ghproxy.cc/$1'         

    # DBeaver，not debaver-ea
    $content = $content -replace 'https?://dbeaver\.io/files/([\d\.]+)/', 'https://ghproxy.cc/https://github.com/dbeaver/dbeaver/releases/download/$1/'
    
    # FastCopy
    $content = $content -replace 'https?://fastcopy\.jp/archive', 'https://ghproxy.cc/https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main'

    # OBS Studio
    $content = $content -replace 'https?://cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Windows\.zip', 'https://ghproxy.cc/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Windows.zip'

    # OBS Studio 2.7
    $content = $content -replace 'https?://cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'https://ghproxy.cc/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Full'

    # Strawberry
    $content = $content -replace 'https?://files\.jkvinge\.net/packages/strawberry/StrawberrySetup-(.+)-mingw-x', 'https://ghproxy.cc/https://github.com/strawberrymusicplayer/strawberry/releases/download/$1/StrawberrySetup-$1-mingw-x'

    # KDE Apps
    # $content = $content -replace 'download\.kde\.org', 'mirrors.nju.edu.cn/kde'

    # 7-Zip
    $content = $content -replace 'www\.7-zip\.org/a', 'mirrors.nju.edu.cn/7-zip'

    # Blender
    $content = $content -replace 'download\.blender\.org', 'mirrors.nju.edu.cn/blender'

    # Cygwin
    $content = $content -replace '//.*/cygwin/', '//mirrors.nju.edu.cn/cygwin/'

    # GIMP
    $content = $content -replace 'download\.gimp\.org/mirror/pub', 'mirrors.nju.edu.cn/gimp'
    
    # Go
    $content = $content -replace 'dl\.google\.com/go', 'mirrors.nju.edu.cn/golang'

    # Gradle
    $content = $content -replace 'services\.gradle\.org/distributions', 'mirror.nju.edu.cn/gradle'

    # Inkscape
    $content = $content -replace 'media\.inkscape\.org/dl/resources/file', 'mirrors.nju.edu.cn/inkscape'

    # Kodi
    $content = $content -replace 'mirrors\.kodi\.tv', 'mirrors.nju.edu.cn/kodi'

    # LaTeX, MiKTeX
    $content = $content -replace '(miktex\.org/download/ctan)|(mirrors.+/CTAN)', 'mirrors.nju.edu.cn/CTAN'

    # Node
    $content = $content -replace 'nodejs\.org/dist', 'mirrors.nju.edu.cn/nodejs-release'
    
    # Python
    $content = $content -replace 'www\.python\.org/ftp/python', 'mirrors.nju.edu.cn/python'

    # Vim
    $content = $content -replace 'ftp\.nluug\.nl/pub/vim/pc', 'mirrors.nju.edu.cn/vim/pc'

    # VirtualBox
    $content = $content -replace 'download\.virtualbox\.org/virtualbox', 'mirrors.nju.edu.cn/virtualbox'

    # VLC
    $content = $content -replace 'download\.videolan\.org/pub', 'mirrors.nju.edu.cn/videolan-ftp'

    # Wireshark
    $content = $content -replace 'www\.wireshark\.org/download', 'mirrors.nju.edu.cn/wireshark'

    # Lunacy
    $content = $content -replace 'lun-eu\.icons8\.com/s/', 'lcdn.icons8.com/'

    # Tor Browser, Tor
    # mirror list: https://raw.githubusercontent.com/torproject/torbrowser-launcher/refs/heads/main/share/torbrowser-launcher/mirrors.txt
    $content = $content -replace 'archive\.torproject\.org/tor-package-archive', 'tor.calyxinstitute.org/dist'

    # Typora
    $content = $content -replace 'download\.typora\.io', 'download2.typoraio.cn'

    # Scripts
    $content = $content -replace '(bucketsdir\\\\).+(\\\\scripts)', '$1scoop-cn$2'

    # 将 suggest 路径改为 scoop-cn
    $content = $content -replace '\"main/|\"extras/|\"versions/|\"nirsoft/|\"sysinternals/|\"php/|\"nerd-fonts/|\"nonportable/|\"java/|\"games/', '"scoop-cn/' 

    # 将 depends 路径改为 scoop-cn
    $content = $content -replace '\"depends\":\s*\"(scoop\-cn/)?', '"depends": "scoop-cn/' 
    
		Set-Content -Path $_.FullName -Value $content
}

