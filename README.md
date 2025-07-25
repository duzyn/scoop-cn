# Scoop 应用库中国加速

![GitHub Actions Workflow Status](https://github.com/duzyn/scoop-cn/actions/workflows/schedule.yml/badge.svg)

## Scoop 在中国使用的问题

Scoop 是一个很优秀的软件包管理工具，官方的安装说明也简单易懂，但是在中国访问却可能在每个环节都会遇到无法下载的问题。依次会遇到的是：

1. 首先从 GitHub Raw 下载 [Scoop 安装脚本](https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1)，此时下载会失败。
2. 如果第一步成功后，会下载 [Scoop 仓库存档](https://github.com/ScoopInstaller/Scoop/archive/master.zip) 和 [Main 应用仓库存档](https://github.com/ScoopInstaller/Main/archive/master.zip)，此时下载又会失败。
3. 如果第二步成功后，会先下载 7-Zip 和 Git 来做后面的事，因为 [7-Zip 的官网](https://www.7-zip.org/) 也是会偶尔无法访问，Git 下载地址在 [GitHub Releases](https://github.com/git-for-windows/git/releases)，此时下载又会失败。
4. 如果第三步成功后，会从官方 Main 应用仓库检出代码，地址在 [GitHub 仓库](https://github.com/ScoopInstaller/Main)，此时下载又会失败。
5. 如果第四步成功后，更新 Scoop 时会从官方 Scoop 仓库检出代码，地址在 [GitHub 仓库](https://github.com/ScoopInstaller/Scoop/)，此时下载又会失败。
6. 后续添加、检出 extras 等应用库都会失败。

如果你使用 Scoop 没有遇到这些问题，恭喜你，后面的内容不用看了。

## 本应用库介绍

本应用库为了解决上述问题，把各个环节的下载地址替换成了国内可加速访问的地址。本应用库使用的是 [GitHub Proxy](https://gh-proxy.net/) 和 [GitHub Actions](https://github.com/features/actions) 。

特性有：

1. 本应用库包含 Scoop 的安装脚本，用于国内用户初次下载安装 Scoop。
2. 本应用库同时包含了 Scoop 官方的十个应用库：main、extras、versions、nirsoft、sysinternals、php、nerd-fonts、nonportable、java、games（可使用命令 `scoop bucket known` 查看），用一个库包含了各家的库，用户不用在多个地方搜索应用。
3. 本应用库把应用的下载地址替换成了国内可加速访问的地址，真正做到能更快更方便地下载和安装应用。
4. 本应用库每小时自动更新一次

## 前提条件

[PowerShell](https://learn.microsoft.com/zh-cn/powershell/) 版本在 5.1 或以上，如果没有 PowerShell 大于 5.1 版本，可以下载安装 [PowerShell Core](https://github.com/PowerShell/PowerShell)。运行以下命令查看：

```powershell
$PSVersionTable.PSVersion.Major # 应该 >= 5.1
```

其次，允许本地运行 PowerShell 脚本，以管理员打开 PowerShell，运行以下命令，回答 Y：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 安装 Scoop 和 scoop-cn（推荐）

此方法会把安装 Scoop 过程中的地址都换成中国可快速访问的地址，并设置好 Scoop，添加本仓库。打开 PowerShell，输入以下命令下载安装：

```powershell
irm https://gh-proxy.net/https://raw.githubusercontent.com/duzyn/scoop-cn/master/install.ps1 | iex
```

或使用其他镜像地址：

```powershell
# 以下命令二选一
irm https://cdn.jsdelivr.net/gh/duzyn/scoop-cn/install.ps1 | iex
irm https://raw.gitmirror.com/duzyn/scoop-cn/master/install.ps1 | iex
```

安装成功后，会提示“Scoop and scoop-cn was installed successfully!”

## 只添加 scoop-cn 仓库

如果已经安装了 Scoop，不想重新安装可以按以下步骤进行：

1. 运行以下命令添加本仓库

    ```powershell
    scoop bucket add scoop-cn https://gh-proxy.net/https://github.com/duzyn/scoop-cn
    ```

2. 把已经安装的 app 改为使用 scoop-cn 来更新。每个 app 安装后在 app 的 current 路径下有个 install.json，里面的 bucket 项的值改为 scoop-cn，这样就把已安装的 app 换到 scoop-cn 了。可以运行以下命令来批量替换：

    ```powershell
    Get-ChildItem -Path "$env:USERPROFILE\scoop\apps" -Recurse -Filter "install.json" | ForEach-Object { (Get-Content -Path $_.FullName -Raw) -replace '"bucket": "(main|extras|versions|nirsoft|sysinternals|php|nerd-fonts|nonportable|java|games)"', '"bucket": "scoop-cn"' | Set-Content -Path $_.FullName }
    ```

    命令中的 `$env:USERPROFILE\scoop\apps` 需根据你实际的 Scoop 安装路径来修改，如果你安装 Scoop 时没有改过安装路径，默认应该是这个。

3. 可以运行 `scoop list` 来检查替换是否成功。比如未修改前是这样的：

    ```powershell
    Installed apps:

    Name          Version           Source         Updated               Info
    ----          -------           ------         -------               ----
    7zip          24.08             main           2024-11-06 17:52:51
    git           2.47.0.2          main           2024-11-06 17:53:04
    ```

    运行命令替换之后变为：

    ```powershell
    Installed apps:

    Name          Version           Source         Updated               Info
    ----          -------           ------         -------               ----
    7zip          24.08             scoop-cn       2024-11-06 17:52:51
    git           2.47.0.2          scoop-cn       2024-11-06 17:53:04
    ```

## 更新 GitHub 代理地址

如果因为 GitHub 代理无法访问（这是时不时会发生的事），导致无法更新本仓库。可以在本仓库使用新 GitHub 代理地址后更新 GitHub 代理地址。

运行以下命令设置新 GitHub 代理地址，下例中 `https://gh-proxy.net` 是当前在使用的：

```powershell
scoop config scoop_repo https://gh-proxy.net/https://github.com/ScoopInstaller/Scoop
git -C "$env:USERPROFILE\scoop\buckets\main" remote set-url origin https://gh-proxy.net/https://github.com/ScoopInstaller/Main
git -C "$env:USERPROFILE\scoop\buckets\scoop-cn" remote set-url origin https://gh-proxy.net/https://github.com/duzyn/scoop-cn
```

## 安装应用

搜索应用：

```powershell
scoop search APPNAME
```

安装应用：

```powershell
scoop install scoop-cn/APPNAME
```

## 查看帮助

要了解 Scoop 的更多用法，请查看 [Scoop 官网](https://scoop.sh/)。或运行命令查看简要的帮助：

```powershell
scoop help
```

![Star History Chart](https://api.star-history.com/svg?repos=duzyn/scoop-cn&type=Date)
