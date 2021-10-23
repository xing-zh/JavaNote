# Docker容器的常用命令

## 1、查看当前正在运行的容器实例

```bash
docker ps
```

- 显示的内容
  - CONTAINER ID：容器id
  - IMAGE：镜像名称
  - COMMAND：docker容器启动内部程序的命令
  - CREATED：容器创建时间
  - STATUS：容器当前状态以及存在时间
  - PORTS：端口映射关系
  - NAMES：容器的名称

## 2、查看当前正在运行，以及曾经运行过的容器实例

```bash
docker ps -a
```

## 3、停止某一个容器

```bash
docker stop [容器的名称/容器的ID]
```

## 4、从docker环境中，移除某一个容器

```bash
docker rm [容器的名称/容器的ID]
```

## 5、查看docker的日志输出

```bash
docker logs [容器的名称/容器的ID]
```

## 6、从宿主机进入到Docker容器内部

- 进入到Docker容器内部，实际上就是：将后台模式转换为前台模式

```bash
docker exec -it [容器的名称/容器的ID] /bin/bash
#退出容器内部
exit 
```

## 7、查看容器的详细信息

```bash
docker inspect [容器的名称/容器的ID]
```

## 8、查看容器的IP地址

```bash
docker inspect —format=’{{.NetworkSettings.IPAddress}}’ [容器的名称/容器的ID]
```

## 9、启动容器

- 开启一个处于停止状态下的容器

```bash
docker start [容器的名称/容器的ID]
```

## 10、重启容器

```bash
docker restart [容器的名称/容器的ID]
```

## 11、删除镜像

```bash
docker rmi [镜像的名称:版本号/镜像的ID]
```

# Docker安装、启动常用镜像

## 一、Docker安装MySQL

1. 从官网上https://hub.docker.com/ 进行镜像的搜索（推荐）
2. 或者使用`docker search mysql`进行命令查找

### 1、下载MySQL镜像

- 在Xshell中，执行如下命令，即可下载镜像

- - `docker pull mysql:5.7`
  - pull：是下拉的意思

- - mysql：是镜像的名称
  - 5.7：是镜像的版本

- 校验镜像是否下载完成
  - `docker images`

![image-20210904121942614](https://gitee.com/yh-gh/img-bed/raw/master/202109181358544.png)

### 2、Docker后台模式运行MySQL

- Docker容器的运行命令是：`docker run`

  - ```bash
    docker run --name mysql01 -p 3306:3306 -v /root/mysql/data:/var/lib/mysql --privileged=true -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7
    ```

- 属性：

- - `--name mysql01`：给Docker容器 定义一个名称mysql01
  - `-p 3306:3306`：将宿主机的3306 映射到Docker容器内部的3306上 （第1个是外部的）
  - `-v /root/mysql/data:/var/lib/mysql`：表示目录映射关系（前者"`:`前"是宿主机目录，后者是容器被映射到宿主机上的目录），可以使用多个－v做多个目录或文件映射。注意：最好做目录映射，在宿主机上做修改，然后共享到容器上。

- - `--privileged=true`：将Docker容器的权限，设置为最高权限 root
  - `-e MYSQL_ROOT_PASSWORD=123456`：配置Docker内部的环境变量

- - `-d`：让容器在后端运行
  - `mysql:5.7`：镜像的名称

- 检验Docker容器是否启动成功

- - `docker ps`

### 3、使用navicat链接mysql

![image-20210904130251065](https://gitee.com/yh-gh/img-bed/raw/master/202109181358500.png)

### 4、Docker前台模式运行MySQL

- ```bash
  docker run --name mysql01 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=12345 -i -t -v /root/mysql/data:/var/lib/mysql --privileged=true mysql:5.7 /bin/bash
  ```

- - `-i`：以前台运行模式进行启动docker容器
  - `-t`：为容器重新分配一个伪输入终端，通常与 -i 同时使用

- - `/bin/bash`：让容器启动完毕后，开启一个内部进程

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181359317.png)

- 这种模式有个特点是：退出容器内部，Docker容器将会自动关闭

### 前台模式和后台模式的区别

- 前台模式的特点：启动之后就立马进入到docker内部
- 后台模式的特点：启动之后，我们的程序依旧在物理上

- 推荐使用**：**后台模式启动

## 二、Docker安装Tomcat

- 在https://hub.daocloud.io/网站上，输入tomcat进行镜像查找

### 1、下载镜像

```bash
docker pull daocloud.io/library/tomcat:8.5.15-jre8
```

- 检验下载`docker images`

![image-20210904130738946](https://gitee.com/yh-gh/img-bed/raw/master/202109181359445.png)

### 2、运行镜像

```bash
docker run -d -p 8080:8080 --name mytomcat daocloud.io/library/tomcat:8.5.15-jre8
```

#### 避坑：如果在启动时出现警告IPv4相关

WARNING: IPv4 forwarding is disabled. Networking will not work.

```bash
#进行编辑配置文件
vi /usr/lib/sysctl.d/00-system.conf
#在其中添加一段
net.ipv4.ip_forward=1
#重启网络
service network restart
```

### 3、进行访问

![image-20210904133118529](https://gitee.com/yh-gh/img-bed/raw/master/202109181359724.png)

### 4、挂载war文件

#### 4.1、运行tomcat，并且`-v`声明docker数据卷

```bash
docker run -d -p 8080:8080 --name mytomcat --privileged=true -v /root/tomcat/webapps:/usr/local/tomcat/webapps daocloud.io/library/tomcat:8.5.15-jre8
```

运行完成，可以在目录中看到创建的数据卷目录

![image-20210904133952720](https://gitee.com/yh-gh/img-bed/raw/master/202109181359982.png)

- 数据卷
  - 作用
    - 通过`-v 宿主机目录:容器中目录`，将容器里面的目录，映射到宿主机上，可以在宿主机对容器类的文件进行更改，同步到容器
  - 好处
    - Docker容器是一种“沙箱”机制，会将容器的环境，容器产生的数据等，统一放置在Docker容器内部。有的时候，可能会出现问题：比如MySQL容器突然异常，无法重启，那么容器内部的数据，也就跟着丢失掉了，使用数据卷就可以解决

#### 4.2、上传war文件

将war文件上传到数据卷目录中

![image-20210904141624203](https://gitee.com/yh-gh/img-bed/raw/master/202109181359133.png)



#### 4.3、进行访问

![image-20210904141959739](https://gitee.com/yh-gh/img-bed/raw/master/202109181359108.png)

如果访问不到，重启一次容器，就可以了

```bash
docker restart mytomcat
```

