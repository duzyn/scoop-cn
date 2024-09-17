## 脚本说明

- 以下脚本对原脚本的扩展和改进,提供更多的灵活性和安装方案,以及更加详细的注释

- 对于某些精简版或修改版系统默认将用户权限提到Administrator的情况提供安装支持选项

- 这里提供了多个函数,其中主要函数是`deploy-ScoopForCNUser `,有两大类调用语法(对应两类部署方案,默认使用第一种)

  - ```powershell
    PS C:\repos\scoop-cn> gcm Deploy-ScoopForCNUser -Syntax
    
    Deploy-ScoopForCNUser [-InstallBasicSoftwares] [-AddMoreBuckets] [-delay <Object>] [<CommonParameters>]
    
    Deploy-ScoopForCNUser [-UseGiteeForkAndBucket] [-AddMoreBuckets] [-delay <Object>] [<CommonParameters>]
    ```

- 如果用户事先安装过`Git`,那么可以直接执行`Deploy-ScoopForCNUser`,其他参数可选

- 对于没有安装过`Git`的用户,建议使用(否则会因为确实Git而无法添加Bucket等操作)

  ```powrershell
  deploy-ScoopForCNUser -InstallBasicSoftwares
  ```

- 或者使用另一种Gitee方案安装

  ```powershell
  deploy-ScoopForCNUser -UseGiteeForkAndBucket
  ```

  

```powershell

function Get-AvailableGithubMirrors
{
    <# 
.SYNOPSIS
列出流行的或可能可用的github加速镜像站
列表中的镜像站可能会过期,可用性不做稳定性和可用性保证

.DESCRIPTION
推荐使用aria2等多线程下载工具来加速下载,让镜像加速效果更加明显
    #>
    [CmdletBinding()]
    param(
        [switch]$ListView,
        [switch]$PassThru
    )

    $m1 = 'https://mirror.ghproxy.com'
    $m2 = 'https://ghproxy.cc'
    $m3 = 'https://github.moeyy.xyz/'
    $m4 = 'https://ghproxy.net/'
    $m5 = 'https://gh.ddlc.top/'
 
    Write-Host 'Available mirrors:'
    $mirrors = @($m1, $m2, $m3, $m4, $m5) 
    

    $s = { 
        $mirrors | ForEach-Object { 
            $i = [array]::IndexOf($mirrors, $_)
            Write-Host " ${i}: $_"
        }
    }

    $s.Invoke()
     
    if ($PassThru)
    {

        return $mirrors
    }
    
}

function Deploy-ScoopByGithubMirrors
{
    
    [CmdletBinding()]
    param (
        
        [switch]$InstallBasicSoftwares,
        $ScriptsDirectory = "$home/Downloads"
    )
    $mirrors = Get-AvailableGithubMirrors -PassThru
    $numOfMirrors = $mirrors.Count
    $range = "[0~$($numOfMirrors-1)]"
    $num = Read-Host -Prompt "Select the number of the mirror you want to use $range ?(default: 0)"
 
    if (!$num)
    {
        Write-Host 'choose the Default 0'
    }
    elseif ( !($num -as [int]))
    {
        Write-Error " Input a number within the range! $range"
    }
    $mirror = $mirrors[$num]
    ## 加速下载scoop原生安装脚本
    $script = (Invoke-RestMethod $mirror/https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1)
 
    $installer = "$ScriptsDirectory/scoop_installer.ps1"
    $installer_cn = "$ScriptsDirectory/scoop_cn_installer.ps1"
    # 利用字符串的Replace方法，将 https://github.com 替换为 $mirror/https://github.com加速
    $script> $installer
    $script.Replace('https://github.com', "$mirror/https://github.com") > $installer_cn
 
    # 根据scoopd官方文档,管理员(权限)安装scoop时需要添加参数 -RunAsAdmin参数,否则会无法安装
    # 或者你可以直接将上述代码下载下来的家目录scoop_installer_cn文件中的相关代码片段注释掉(Deny-Install 调用语句注释掉)
    $r = Read-Host -Prompt 'Install scoop as Administrator Privilege? [Y/n]'
    if ($r)
    {
        #必要时请手动打开管理员权限的powershell,然后运行此脚本
        Invoke-Expression "& $installer_cn -RunAsAdmin"
    }
    else
    {
 
        Invoke-Expression "& $installer_cn"
    }
 
    # 将 Scoop 的仓库源替换为代理的
    scoop config scoop_repo $mirror/https://github.com/ScoopInstaller/Scoop
 
    New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket"
    # 可选部分
 
 
    ## 如果没有安装 Git等常用工具,可以解开下面的注释
    ## 先下载几个必需的软件的 JSON，组成一个临时的应用仓库
    if ($InstallBasicSoftwares)
    {
        New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip"
        New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git"
        # 7zip软件资源
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/7zip.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\7zip.json"
        #注册7-zip的右键菜单等操作
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\install-context.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\uninstall-context.reg"
        # git软件资源
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/git.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\git.json"
     
        #注册git右键菜单等操作
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-context.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-context.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-file-associations.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-file-associations.reg"
        #注册aria2
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/aria2.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\aria2.json"
 
        # 安装时注意顺序是 7-Zip, Git, Aria2
        scoop install scoop-cn/7zip
        scoop install scoop-cn/git
        scoop install scoop-cn/aria2
        # 推荐使用aria2,设置多路下载
        scoop config aria2-split 16
    }
     
 
    # 将 Scoop 的 main 仓库源替换为代理加速过的
    if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\main")
    {
        # 先移除默认的源，然后添加同名bucket和加速后的源
        scoop bucket rm main
    }
    Write-Host 'Adding speedup main bucket...'+" powered by： [$mirror]"
    scoop bucket add main $mirror/https://github.com/ScoopInstaller/Main
 
    # 之前的scoop-cn 库是临时的,还不是来自Git拉取的完整库，删掉后，重新添加 Git 仓库
    Write-Host 'remove Temporary scoop-cn bucket...'
    if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\scoop-cn")
    {
        scoop bucket rm scoop-cn
    }
    Write-Host 'Adding scoop-cn bucket (from git repository)...'
    scoop bucket add scoop-cn $mirror/https://github.com/duzyn/scoop-cn
 
    # Set-Location "$env:USERPROFILE\scoop\buckets\scoop-cn"
    # git config pull.rebase true
 
    Write-Host 'scoop and scoop-cn was installed successfully!'
     
}
function Deploy-ScoopByGitee
{
    param (
                
    )
    # 脚本执行策略更改
    Set-ExecutionPolicy -ExecutionPolicy bypass -Scope CurrentUser
    #如果询问, 输入Y或A，同意
    
    # 执行安装命令（默认安装在用户目录下，如需更改请执行“自定义安装目录”命令）
    Invoke-WebRequest -useb scoop.201704.xyz | Invoke-Expression
    ## 自定义安装目录（注意将目录修改为合适位置)
    # irm scoop.201704.xyz -outfile 'install.ps1'
    # .\install.ps1 -ScoopDir 'D:\Scoop' -ScoopGlobalDir 'D:\GlobalScoopApps'
    #添加包含国内软件的的scoopcn bucket,其他bucket可以自行添加
    scoop bucket add scoopcn https://gitee.com/scoop-installer/scoopcn
}
function Add-ScoopBuckets
{
    <# 
            .SYNOPSIS
            基本上，添加spc这个bucket就够了,软件数量很丰富
            .DESCRIPTION
            可以根据自己的需要往里面修改或添加更多的bucket
            #>
    [CmdletBinding()]
    param (
                
    )
             
    Write-Host 'Adding more buckets...(It may take a while, please be patient!)'
    scoop bucket add spc $mirror/https://github.com/lzwme/scoop-proxy-cn   
            
}
function Deploy-ScoopForCNUser
{
 
    # & "$PSScriptRoot\scoopDeploy.ps1"

    <# 
.SYNOPSIS
国内用户部署scoop
.Description
允许用户在一台没有安装git等软件的windows电脑上部署scoop包管理工具
如果你事先安装好了git,那么可以选择不安装(默认行为)

脚本会通过github镜像站加速各个相关链接进行达到提速的目的
    通过加速站下载原版安装脚本
    通过替换原版安装脚本中的链接为加速链接来加速安装scoop
    根据需要创建临时的bucket,让用户可以通过scoop来安装git等软件
针对某些Administrator用户,scoop默认拒绝安装,这里根据官方指南,做了修改,允许用户选择仍然安装
.NOTES
代码来自git/gitee上的开源项目(感谢作者的相关工作和贡献)


.DESCRIPTION
使用镜像加速下载scoop原生安装脚本并做一定的修改提供加速安装(但是稳定性和可靠性不做保证)
此脚本参考了多个开源方案,为提供了更多的灵活性和备用方案的选择,尤其是可以添加spc这个大型bucket,以提供更多的软件包
.LINK
镜像加速参考
https://github.akams.cn/ 
.LINK
https://gitee.com/twelve-water-boiling/scoop-cn
.LINK
# 提供 Deploy-ScoopByGitee 实现资源
https://gitee.com/scoop-installer/scoop
.LINK
# 提供 Deploy-scoopbyGithubMirrors 实现方式
https://lzw.me/a/scoop.html#2%20%E5%AE%89%E8%A3%85%20Scoop
.LINK
# 提供 大型bucket spc 资源
https://github.com/lzwme/scoop-proxy-cn
.LINK
相关博客
#提供 Deploy-ScoopForCNUser 整合与改进
https://cxxu1375.blog.csdn.net/article/details/121067836

在这里搜索scoop相关笔记
https://gitee.com/xuchaoxin1375/blogs/blob/main/windows 

#>
    [CmdletBinding(DefaultParameterSetName = 'Manual')]
    param(
       
        # 是否仅查看内置的候选镜像列表
        # [switch]$CheckMirrorsBuildin,
        # 从镜像列表中选择镜像
        # [switch]$SelectMirrorFromList,
        # 是否安装基础软件，比如git等（考虑到有些用户已经安装过了，我们可以按需选择）
        [parameter(ParameterSetName = 'Manual')]
        [switch]$InstallBasicSoftwares,
        [parameter(ParameterSetName = 'Gitee')]
        [switch]$UseGiteeForkAndBucket,
        # 是否添加一个大型的bucket
        [switch]$AddMoreBuckets,
        # 延迟启动安装,给用户一点时间反悔
        $delay = 3
    )
    
    
    # return $mirror

    # 安装 Scoop
    # Gitee方案(简短,执行完后自动退出)
    if ($UseGiteeForkAndBucket)
    {
        Write-Host 'UseGiteeForkAndBucket scheme...'
        Start-Sleep $delay
        Deploy-ScoopByGitee
    }
    # 手动配置镜像方案
    else
    {
        Write-Host 'Use manual scheme...'
        # Start-Sleep $delay
        Deploy-ScoopByGithubMirrors -InstallBasicSoftwares:$InstallBasicSoftwares
    }

    if ($AddMoreBuckets)
    {
        # 添加bucket,包含很多软件包(几乎scoop bucket known列出的bucket的软件都能够在spc中找到)
        Add-ScoopBuckets
    }

    #检查用户安装了哪些bucket,以及对应的bucket源链接
    scoop bucket list

}

```

### Notes

- 上述脚本经过测试,可以正常工作
- 可以新建一个本地账户(利用语句`net user tester 1 /add`创建一个测试用户`tester`,密码是`1`);登陆`tester`来验证其是否能工作

### 获取脚本文件及其使用

- 可以复制粘贴上述代码到文本文件,然后修改后缀为`.ps1`

- 也从本仓库的`Deploy-ScoopForCNUser`中保存脚本文件

- 然后打开powershell执行这个脚本文件,会导入其中的函数

  - 如果执行失败,可以设置执行策略:

    ```powershell
    set-executionPolicy -Scope CurrentUser -ExecutionPolicy bypass
    ```

  - 然后重新尝试