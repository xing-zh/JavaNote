# Linux操作系统

- 为什么要学习Linux
  - 我们一般都是在windows上开发，在linux去做部署
- 目前来讲，我们知道的操作系统
  - 个人操作系统
    - Windows系统
    - mac系统
  - 服务器操作系统（要求稳定，节省系统资源）
    - Linux系统（开源）
    - unix系统（付费）
- 开发场景：Windows系统，mac系统
- 部署场景：unix系统（中大型服务器），linux系统
- Linux操作系统的历史
  - 91年： 由芬兰大学的大学生李拉斯开发的一套类Unix的操作系统
  - 是一个开源的类Unix计算机操作系统的统称
- 常见Linux版本
  - Ubuntu 乌班图
  - Red Hat 红帽子
  - CentOS 稳定小巧

# 第三方工具操作linux

这里使用的是MobaXterm

## 1、查看系统的IP

命令：`ip addr`

![image-20210810121540002](https://gitee.com/yh-gh/img-bed/raw/master/202109181442336.png)

2中没有出现ip地址，说明没有分配ip

## 2、分配ip地址

命令：`vi /etc/sysconfig/network-scripts/ifcfg-ens33`

进入配置文件进行修改ONBOOT为yes，表示服务启动时自动执行该文件，wq保存退出

![image-20210810134034965](https://gitee.com/yh-gh/img-bed/raw/master/202109181442996.png)

重启网络服务，命令：`service network restart`

重启完之后，再次查看ip地址

命令：`ip addr`

![image-20210810134413047](https://gitee.com/yh-gh/img-bed/raw/master/202109181442532.png)

发现第二个已经有了ip地址

## 3、MobaXterm连接

![image-20210810134509018](https://gitee.com/yh-gh/img-bed/raw/master/202109181442341.png)

![image-20210810134525843](https://gitee.com/yh-gh/img-bed/raw/master/202109181442242.png)

![image-20210810134718344](https://gitee.com/yh-gh/img-bed/raw/master/202109181442941.png)

![image-20210810134750523](https://gitee.com/yh-gh/img-bed/raw/master/202109181442299.png)

## 4、连接成功

![image-20210810134813026](https://gitee.com/yh-gh/img-bed/raw/master/202109181442639.png)

# Linux的目录结构

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181442740.jpg)

- **/bin**：
  bin 是 Binaries (二进制文件) 的缩写, 这个目录存放着最经常使用的命令。

- **/boot：**
  这里存放的是启动 Linux 时使用的一些核心文件，包括一些连接文件以及镜像文件。

- **/dev ：**
  dev 是 Device(设备) 的缩写, 该目录下存放的是 Linux 的外部设备，在 Linux 中访问设备的方式和访问文件的方式是相同的。

- **/etc：**
  etc 是 Etcetera(等等) 的缩写,这个目录用来存放所有的系统管理所需要的配置文件和子目录。

- **/home**：
  用户的主目录（除了超级管理员root），在 Linux 中，每个用户都有一个自己的目录，一般该目录名是以用户的账号命名的，如上图中的 alice、bob 和 eve。

- **/lib**：
  lib 是 Library(库) 的缩写这个目录里存放着系统最基本的动态连接共享库，其作用类似于 Windows 里的 DLL 文件。几乎所有的应用程序都需要用到这些共享库。

- **/lost+found**：
  这个目录一般情况下是空的，当系统非法关机后，这里就存放了一些文件。

- **/media**：
  linux 系统会自动识别一些设备，例如U盘、光驱等等，当识别后，Linux 会把识别的设备挂载到这个目录下。

- **/mnt**：
  系统提供该目录是为了让用户临时挂载别的文件系统的，我们可以将光驱挂载在 /mnt/ 上，然后进入该目录就可以查看光驱里的内容了。

- **/opt**：
  opt 是 optional(可选) 的缩写，这是给主机额外安装软件所摆放的目录。比如你安装一个ORACLE数据库则就可以放到这个目录下。默认是空的。

- **/proc**：
  proc 是 Processes(进程) 的缩写，/proc 是一种伪文件系统（也即虚拟文件系统），存储的是当前内核运行状态的一系列特殊文件，这个目录是一个虚拟的目录，它是系统内存的映射，我们可以通过直接访问这个目录来获取系统信息。
  这个目录的内容不在硬盘上而是在内存里，我们也可以直接修改里面的某些文件，比如可以通过下面的命令来屏蔽主机的ping命令，使别人无法ping你的机器：

  ```
  echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
  ```

- **/root**：
  该目录为系统管理员，也称作超级权限者的用户主目录。

- **/sbin**：
  s 就是 Super User 的意思，是 Superuser Binaries (超级用户的二进制文件) 的缩写，这里存放的是系统管理员使用的系统管理程序。

- **/selinux**：
   这个目录是 Redhat/CentOS 所特有的目录，Selinux 是一个安全机制，类似于 windows 的防火墙，但是这套机制比较复杂，这个目录就是存放selinux相关的文件的。

- **/srv**：
   该目录存放一些服务启动之后需要提取的数据。

- **/sys**：

  这是 Linux2.6 内核的一个很大的变化。该目录下安装了 2.6 内核中新出现的一个文件系统 sysfs 。

  sysfs 文件系统集成了下面3种文件系统的信息：针对进程信息的 proc 文件系统、针对设备的 devfs 文件系统以及针对伪终端的 devpts 文件系统。

  该文件系统是内核设备树的一个直观反映。

  当一个内核对象被创建的时候，对应的文件和目录也在内核对象子系统中被创建。

- **/tmp**：
  tmp 是 temporary(临时) 的缩写这个目录是用来存放一些临时文件的。

- **/usr**：
   usr 是 unix shared resources(共享资源) 的缩写，这是一个非常重要的目录，用户的很多应用程序和文件都放在这个目录下，类似于 windows 下的 program files 目录。

- **/usr/bin：**
  系统用户使用的应用程序。

- **/usr/sbin：**
  超级用户使用的比较高级的管理程序和系统守护程序。

- **/usr/src：**
  内核源代码默认的放置目录。

- **/var**：
  var 是 variable(变量) 的缩写，这个目录中存放着在不断扩充着的东西，我们习惯将那些经常被修改的目录放在这个目录下。包括各种日志文件。

- **/run**：
  是一个临时文件系统，存储系统启动以来的信息。当系统重启时，这个目录下的文件应该被删掉或清除。如果你的系统上有 /var/run 目录，应该让它指向 run。

在 Linux 系统中，有几个目录是比较重要的，**平时需要注意不要误删除或者随意更改内部文件。**

- **/etc**： 上边也提到了，这个是系统中的配置文件，如果你更改了该目录下的某个文件可能会导致系统不能启动。
- **/bin, /sbin, /usr/bin, /usr/sbin**: 这是系统预设的执行文件的放置目录，比如 ls 就是在 /bin/ls 目录下的。值得提出的是，/bin, /usr/bin 是给系统用户使用的指令（除root外的通用户），而/sbin, /usr/sbin 则是给 root 使用的指令。
- **/var**： 这是一个非常重要的目录，系统上跑了很多程序，那么每个程序都会有相应的日志产生，而这些日志就被记录到这个目录下，具体在 /var/log 目录下，另外 mail 的预设放置也是在这里。

