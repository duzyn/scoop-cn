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
    $Content = Get-Content $_.FullName

    # GitHub Releases
    $Content = $Content -replace '(https?://github\.com/.+/releases/.*download)', 'https://ghgo.xyz/$1' 

    # GitHub Archive
    $Content = $Content -replace '(https?://github\.com/.+/archive/)', 'https://ghgo.xyz/$1' 

    # GitHub Raw
    $Content = $Content -replace '(https?://raw\.githubusercontent\.com)', 'https://ghgo.xyz/$1' 
    $Content = $Content -replace '(https?://github\.com/.+/raw/)', 'https://ghgo.xyz/$1'          

    # KDE Apps
    $Content = $Content -replace 'download\.kde\.org', 'mirrors.nju.edu.cn/kde' 

    # 7-Zip
    $Content = $Content -replace 'www\.7-zip\.org/a', 'mirrors.nju.edu.cn/7-zip' 

    # LaTeX, MiKTeX
    $Content = $Content -replace '(miktex\.org/download/ctan)|(mirrors.+/CTAN)', 'mirrors.nju.edu.cn/CTAN' 

    # Node
    $Content = $Content -replace 'nodejs\.org/dist', 'mirrors.nju.edu.cn/nodejs-release' 
    
    # Python
    $Content = $Content -replace 'www\.python\.org/ftp/python', 'mirrors.nju.edu.cn/python' 

    # Go
    $Content = $Content -replace 'dl\.google\.com/go', 'mirrors.nju.edu.cn/golang' 

    # VLC
    $Content = $Content -replace 'download\.videolan\.org/pub', 'mirrors.nju.edu.cn/videolan-ftp' 

    # Inkscape
    $Content = $Content -replace 'media\.inkscape\.org/dl/resources/file', 'mirrors.nju.edu.cn/inkscape' 

    # DBeaver
    $Content = $Content -replace 'https?://dbeaver\.io/files', 'https://ghgo.xyz/https://github.com/dbeaver/dbeaver/releases/download'

    # OBS Studio
    $Content = $Content -replace 'https?://cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Windows\.zip', 'https://ghgo.xyz/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Windows.zip'

    # OBS Studio 2.7
    $Content = $Content -replace 'https?://cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'https://ghgo.xyz/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Full'

    # GIMP
    $Content = $Content -replace 'download\.gimp\.org/mirror/pub', 'mirrors.nju.edu.cn/gimp' 

    # Blender
    $Content = $Content -replace 'download\.blender\.org', 'mirrors.nju.edu.cn/blender' 

    # VirtualBox
    $Content = $Content -replace 'download\.virtualbox\.org/virtualbox', 'mirrors.nju.edu.cn/virtualbox' 

    # Wireshark
    $Content = $Content -replace 'www\.wireshark\.org/download', 'mirrors.nju.edu.cn/wireshark' 

    # Lunacy
    $Content = $Content -replace 'lun-eu\.icons8\.com/s/', 'lcdn.icons8.com/' 

    # Strawberry
    $Content = $Content -replace 'https?://files\.jkvinge\.net/packages/strawberry/StrawberrySetup-(.+)-mingw-x', 'https://ghgo.xyz/https://github.com/strawberrymusicplayer/strawberry/releases/download/$1/StrawberrySetup-$1-mingw-x' 

    # Vim
    $Content = $Content -replace 'ftp\.nluug\.nl/pub/vim/pc', 'mirrors.nju.edu.cn/vim/pc' 

    # Cygwin
    $Content = $Content -replace '//.*/cygwin/', '//mirrors.nju.edu.cn/cygwin/' 

    # Tor Browser, Tor
    $Content = $Content -replace 'archive\.torproject\.org/tor-package-archive', 'tor.calyxinstitute.org/dist' 

    # FastCopy
    $Content = $Content -replace 'https?://fastcopy\.jp/archive', 'https://ghgo.xyz/https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main' 

    # Kodi
    $Content = $Content -replace 'mirrors\.kodi\.tv', 'mirrors.nju.edu.cn/kodi' 

    # Typora
    $Content = $Content -replace 'download\.typora\.io', 'download2.typoraio.cn' 

		# Gradle
		$Content = $Content -replace 'services\.gradle\.org/distributions', 'mirror.nju.edu.cn/gradle' 

    # Scripts
    $Content = $Content -replace '(bucketsdir\\\\).+(\\\\scripts)', '$1scoop-cn$2' 

    # 将 suggest 路径改为 scoop-cn
    $Content = $Content -replace '\"main/|\"extras/|\"versions/|\"nirsoft/|\"sysinternals/|\"php/|\"nerd-fonts/|\"nonportable/|\"java/|\"games/', '"scoop-cn/' 

    # 将 depends 路径改为 scoop-cn
    $Content = $Content -replace '\"depends\":\s*\"(scoop\-cn/)?', '"depends": "scoop-cn/' 
    
		Set-Content -Path $_.FullName -Value $Content
}

