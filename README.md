# Scoop 应用库中国加速

![GitHub Actions Workflow Status](https://github.com/duzyn/scoop-cn/actions/workflows/schedule.yml/badge.svg)

## Scoop 在中国使用的问题

Scoop 是一个很优秀的软件包管理工具，官方的安装说明也简单易懂，但是在中国访问却可能在每个环节都会遇到无法下载的问题。依次会遇到的是：

1. 首先从 GitHub Raw 下载 [Scoop 安装脚本](https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1)，此时下载会失败。
2. 如果第一步成功后，会下载 [Scoop 库存档](https://github.com/ScoopInstaller/Scoop/archive/master.zip) 和 [Main 应用库存档](https://github.com/ScoopInstaller/Main/archive/master.zip)，此时下载又会失败。
3. 如果第二步成功后，会先下载 7-Zip 和 Git 来做后面的事，因为 [7-Zip 的官网](https://www.7-zip.org/) 也是会偶尔无法访问，Git 下载地址在 [GitHub Releases](https://github.com/git-for-windows/git/releases)，此时下载又会失败。
4. 如果第三步成功后，会从官方 Main 应用库检出代码，地址在 [GitHub 库](https://github.com/ScoopInstaller/Main)，此时下载又会失败。
5. 如果第四步成功后，更新 Scoop 时会从官方 Scoop 库检出代码，地址在 [GitHub 库](https://github.com/ScoopInstaller/Scoop/)，此时下载又会失败。
6. 后续添加、检出 extras 等应用库都会失败。

如果你使用 Scoop 没有遇到这些问题，恭喜你，后面的内容不用看了。

## 简介

本应用库为了解决上述问题，把各个环节的下载地址替换成了国内可加速访问的地址。本应用库使用的是 [GitHub Proxy](https://gh-proxy.org/) 和 [GitHub Actions](https://github.com/features/actions) 。

特性有：

1. 本应用库包含 Scoop 的安装脚本，用于国内用户初次下载安装 Scoop。
2. 本应用库同时包含了 Scoop 官方的十个应用库：main、extras、versions、nirsoft、sysinternals、php、nerd-fonts、nonportable、java、games（可使用命令 `scoop bucket known` 查看），用一个库包含了各家的库，用户不用在多个地方搜索应用。
3. 本应用库把应用的下载地址替换成了国内可加速访问的地址，真正做到能更快更方便地下载和安装应用。
4. 本应用库每天自动更新一次

## 安装

打开命令提示符，运行以下命令：

```cmd
powershell -ExecutionPolicy RemoteSigned -Command "Invoke-RestMethod -Uri https://gh-proxy.org/https://raw.githubusercontent.com/duzyn/scoop-cn/master/install.ps1 | Invoke-Expression"
```

## 更新 GitHub 代理地址

如果因为 GitHub 代理无法访问（这是时不时会发生的事），导致无法更新本库，需要更新本库的 GitHub 代理地址（当前使用 `https://gh-proxy.org`）。

打开命令提示符，运行以下命令设置新 GitHub 代理地址：

```cmd
scoop config scoop_repo https://gh-proxy.org/https://github.com/ScoopInstaller/Scoop.git
git -C "%USERPROFILE%\scoop\buckets\main" remote set-url origin https://gh-proxy.org/https://github.com/duzyn/scoop-cn.git
```

## 贡献者

<a href="https://github.com/duzyn"><img src="https://github.com/duzyn.png" width="50px;" alt="duzyn"/></a>
<a href="https://github.com/maoyeedy"><img src="https://github.com/maoyeedy.png" width="50px;" alt="maoyeedy"/></a>
<a href="https://github.com/techoc"><img src="https://github.com/techoc.png" width="50px;" alt="techoc"/></a>
<a href="https://github.com/Zacharia2"><img src="https://github.com/Zacharia2.png" width="50px;" alt="Zacharia2"/></a>
