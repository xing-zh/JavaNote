# Docker虚拟进程技术

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181357965.jpeg)

- Docker是一种开源的虚拟进程技术，基于GO语言进行开发的
- Docker可以让开发者自己打包我们自己的应用或依赖包到一个轻量级的，可移植的容器中去。然后，再一发布，那么就可以在所有的Linux上进行运行，一次构建，到处使用

- Docker容器技术，一定是依托Linux操作系统存在
- 镜像产生出来的程序，我们叫“容器”。容器的完成使用一种“沙箱”机制

## 沙箱的概念

- 沙箱是一种虚拟进程技术，它的特点：沙箱之间相互独立，互不干扰。并且对现有的Linux系统不会产生任何的影响
  - 搭建测试，生产环境
  - 发布自己的应用程序

## 使用Docker的原因

- 保证开发，测试，上线环境统一
- 更快速的交付和部署
- 提供比虚拟机更为高效的虚拟技术
- 可以更轻松的迁移或者横向扩展

## Docker和Vmware虚拟机的区别

- VM是一个运行在宿主机之上的完整的操作系统，VM运行时，需要消耗宿主机大量系统资源，例如：CPU，内存，硬盘等一系列的资源。Docker容器与VM不一样，它只包含了应用程序以及各种依赖库
- 正因为它占用系统资源非常少，所以它更加的轻量。它在启动时，可能只需要简单的一个命令就可以了。启动仅仅只需要几秒或几十秒钟就可以完成。对于宿主机来讲，承担VM可能5-10个就已经非常厉害了 ，但是Docker容器很轻松就承担几千个。而且网络配置相对而言也比较简单，主要以桥接方式为主

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181358005.png)

## Docker的应用场景

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181358765.jpeg)

- 开发，测试，生产环境上使用

## Docker容器的3个概念

### 一、Docker镜像

Docker镜像是由文件系统叠加而成（是一种文件的存储形式）。最底端是一个文件引导系统，即bootfs，这很像典型的Linux/Unix的引导文件系统。Docker用户几乎永远不会和引导系统有什么交互。实际上，当一个容器启动后，它将会被移动到内存中，而引导文件系统则会被卸载，以留出更多的内存供磁盘镜像使用。Docker容器启动是需要的一些文件，而这些文件就可以称为Docker镜像。

<img src="https://gitee.com/yh-gh/img-bed/raw/master/202109181358388.png" alt="image-20210621121209160" style="zoom:150%;" />

镜像是构建Docker的基石。用户基于镜像来运行自己的容器。镜像也是Docker生命周期中的“构建”部分。镜像是基于联合文件系统的一种层式结构，由一系列指令一步一步构建出来。例如：添加一个文件；执行一个命令；打开一个窗口。也可以将镜像当作容器的“源代码”。镜像体积很小，非常“便携”，易于分享、存储和更新。

### 二、Docker容器

Docker可以帮助你构建和部署容器，你只需要把自己的应用程序或者服务打包放进容器即可。容器是基于镜像启动起来的，容器中可以运行一个或多个进程。我们可以认为，镜像是Docker生命周期中的构建或者打包阶段，而容器则是启动或者执行阶段。 容器基于镜像启动，一旦容器启动完成后，我们就可以登录到容器中安装自己需要的软件或者服务。

所以Docker容器就是：

一个镜像格式；

一些列标准操作；

一个执行环境。

Docker借鉴了标准集装箱的概念。标准集装箱将货物运往世界各地，Docker将这个模型运用到自己的设计中，唯一不同的是：集装箱运输货物，而Docker运输软件。

和集装箱一样，Docker在执行上述操作时，并不关心容器中到底装了什么，它不管是web服务器，还是数据库，或者是应用程序服务器什么的。所有的容器都按照相同的方式将内容“装载”进去。

Docker也不关心你要把容器运到何方：我们可以在自己的笔记本中构建容器，上传到Registry，然后下载到一个物理的或者虚拟的服务器来测试，在把容器部署到具体的主机中。像标准集装箱一样，Docker容器方便替换，可以叠加，易于分发，并且尽量通用。

使用Docker，我们可以快速的构建一个应用程序服务器、一个消息总线、一套实用工具、一个持续集成（CI）测试环境或者任意一种应用程序、服务或工具。我们可以在本地构建一个完整的测试环境，也可以为生产或开发快速复制一套复杂的应用程序栈。

### 三、Docker仓库

专门用于放置镜像的地方，镜像可以从网络上下载，也可以自己去产生。最大的公开仓库是 Docker Hub(https://hub.docker.com/)。

## Docker的运行原理

![image-20210902231732667](https://gitee.com/yh-gh/img-bed/raw/master/202109181358974.png)

# Docker引擎的安装

- 安装Docker，首先需要先确定你的操作系统一定是Linux
- 并且的Linux的内核版本一定要大于3.8以上

## 1、检查Linux的内核版本

```bash
uname -r
```

## 2、更新yum

```bash
yum update
```

## 3、安装Docker的依赖插件

```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
```

## 4、配置国内Docker加速源

```bash
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

## 5、检查yum中关于Docker的版本

```bash
yum list docker-ce --showduplicates | sort -r
```

## 6、安装Docker

```bash
yum install docker-1.13.1-162.git64e9980.el7.centos.x86_64
```

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181358359.png)

## 7、检查Docker版本

```bash
docker -v
```

## 8、设置Docker开机启动

```bash
systemctl enable docker
```

## 9、开启Docker引擎

```bash
systemctl start|restart|stop docker
```

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181358428.png)

# Docker使用之前的准备工作

- 镜像：可以来自于自己构建，也可以来自于网络
- Docker镜像原本来自国外，地址：https://hub.docker.com/

- 从国外服务器获取镜像时，由于跨国际，可能非常慢，此时就需要配置国内镜像加速源

## 1、配置国内Docker加速源

登录阿里云：https://www.aliyun.com/，访问阿里容器服务

![image-20210621113420658](https://gitee.com/yh-gh/img-bed/raw/master/202109181358110.png)

![image-20210621113549736](https://gitee.com/yh-gh/img-bed/raw/master/202109181358269.png)

## 2、创建配置目录

```bash
sudo mkdir -p /etc/docker
```

## 3、配置加速器

```bash
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://m4s4ozon.mirror.aliyuncs.com"]
}
EOF
```

![image-20210904114441514](https://gitee.com/yh-gh/img-bed/raw/master/202109181358605.png)

## 4、重启Docker服务

以此执行下列命令

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

- 到此，Docker容器使用之前的准备工作，就告一段落

