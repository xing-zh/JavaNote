# 核心命令

## 目录操作

### 1、创建目录

创建单级目录：`mkdir 目录名`

创建多级目录：`mkdir -p 目录1/目录2/目录3`

### 2、删除目录

删除单级目录：`rmdir 目录名`（删除时必须保证目录中为空）

### 3、切换目录

从根目录开始：`cd /目录名`

从当前目录开始：`cd 目录名`

后退到上一层目录：`cd ..`

后退到根目录：`cd /`

切换到最近访问的目录：`cd -`

返回当前用户所拥有的目录（home中的家或root）：`cd ~`

### 4、浏览目录

显示当前目录下的文件和文件夹信息（没有隐藏文件和系统文件）：`ls`

显示某个路径文件夹中文件和文件夹信息：`ls 文件夹名`

显示当前目录下所有的文件和文件夹信息，包括隐藏文件和系统文件：`ls -a`

显示当前目录下的文件和文件夹详细信息（权限、时间等）（没有隐藏文件和系统文件）：`ls -l`（简写：`ll`）

显示当前目录下所有的文件和文件夹详细信息，包括隐藏文件和系统文件：`ls -la`（简写：`ll -a`）

显示当前工作目录：`pwd`

## 文件操作

### 1、创建文件

`touch 文件名`

`vi 不存在的文件名`

### 2、删除文件

询问删除：`rm 文件名`

强制删除（不询问）：`rm -f 文件名`

递归删除文件夹和文件夹下所有文件：`rm -rf 文件夹名`

### 3、编辑文件

进入命令模式：`vi 文件名`，此时可以运行一些命令，如在某行执行命令`dd`删除一整行

进入编辑模式：`i/a/o`

退出编辑模式进入命令模式：按键esc

进入底线命令模式：`:`（`wq`：保存并退出；`q!`：强制退出不保存）

### 4、查看文件

查看所有内容：`cat 文件名`

分页查看内容：

- `less 文件名`（空格：下一页，回车：下一行，b：上一页，q：退出）-N：显示行号；-m：显示百分比
- 显示百分比，到末尾自动退出`more 文件名`（空格：下一页，回车：下一行，b：上一页，q：退出）

查看前n行：`head -n 文件名`

查看后n行：`tail -n 文件名`

### 5、压缩文件

`tar`：既可以打包（不改变源文件大小），也可以压缩（缩小源文件大小）

- 压缩或打包
  - 打包：`tar -cvf 打包后文件名 打包的文件`
  - 压缩：`tar -zcvf 压缩后文件名.tar.gz 压缩的文件`
- 解压缩或解包
  - 解包：`tar -xvf 包名`
  - 解压缩：`tar -zxvf 压缩包名` -C 指定目录

### 6、移动文件和重命名

`mv 文件名 目标文件名`

## 查找

- 按照文件属性查找（文件名、创建时间、大小等）：`find 属性`
  - 文件名：`find /范围 -name '文件全名'`，`find /范围 -name '*.后缀'`
  - 
- 按照文件内容查找（区分大小写）
  - `grep '查找内容' 需要查找的文件`
    - `-i` 不区分大小写
    - `-v` 排除符合条件的
    - `-n`打印行号
    - `-r`递归查找范围中的所有文件

## 管道命令

可以一次性运行多个Linux命令，第一个命令的结果，作为后一个命令的参数

`cat 1.txt | grep 'how'`

# 其他命令

## 文件权限

![image-20210810171623809](https://gitee.com/yh-gh/img-bed/raw/master/202109181443143.png)

### 声明格式

- 第一位：-/d（-为文件，d为文件夹）第二位到第十位：权限描述，每三个一组
  - 第一组：所属用户的权限
  - 第二组：所属组的权限
  - 第三组：其他用户的权限

### 权限分类

- 文件夹
  - r：可查看文件夹内容
  - w：可以在文件夹中创建、删除、修改文件和子文件夹
  - x：可以进入文件夹
- 文件
  - r：可以查看文件内容
  - w：可以编辑文件
  - x：可以执行该可执行文件

### 修改权限

- 方式一：
  - 通过权限赋予对象的字母：所属用户：u，所属组：g，其他用户：o
    - 增加权限：`chmod u+w 文件名`
    - 更改权限：`chmod u=rw 文件名`
    - 删除权限：`chmod u-x 文件名`
- 方式二：
  - 通过权限数值：r：4；w：2；x：1
    - `chmod 权限数值之和 文件名`

## 用户操作

### 1、创建新用户

`useradd 用户名`

### 2、更改用户密码

`passwd 用户名`

### 3、删除用户

`userdel -r 用户名`

## 网络配置

### 1、查看ip地址

`ip addr`

### 2、修改网络配置

`vi /etc/sysconfig/network-scripts/ifcfg-ens33`

### 3、重启网络服务

`service network restart`

### 4、停止网络服务

`service network stop`

### 5、开启网络服务

`service network start`

### 6、查看网络服务状态

`service network status`

### 7、ping查看网络是否连通

`ping www.baidu.com`

### 8、防火墙

```bash
#关闭防火墙
systemctl stop firewalld.service

#开启防火墙
systemctl start firewalld.service

# 查看白名单列表
firewall-cmd --zone=public --list-ports

# 添加白名单端口
firewall-cmd --zone=public --add-port=8080/tcp --permanent

# ****修改后需要重启防火墙****
firewall-cmd --reload

# 查看防火墙状态，是否是running
firewall -cmd --state

# 列出支持的zone
firewall-cmd --get-zones

# 列出支持的服务，在列表中的服务是放行的
firewall-cmd --get-services

# 查看已开放的端口
firewall-cmd --zone=public --list-ports

# 永久添加80端口
firewall-cmd --add-port=2181/tcp --permanent

# 永久删除80端口
firewall-cmd --remove-port=2181/tcp --permanent

# 永久生效，没有此参数重启后失效
--permanent
```

## 进程管理

### 1、查看进程

- 查看当前用户的进程：`ps`
  - 查看系统的所有进程：`-e`
  - 查看进程的详细信息：`-f`

### 2、结束进程

- 准备结束进程：`kill PID`
  - 立即结束进程：`-9`

# 软件安装

## 1、安装方式

### rpm

安装包格式为：mysql.rpm

缺陷：一个软件通常存在多个依赖的rpm，安装过于繁琐

### yum

只需要一个命令，就可以自动化安装

缺陷：安装的软件版本，依赖于yum源

#### 命令：

查看yum源中的所有软件：`yum list`

- 安装软件：`yum install 软件名`
  - 自动应答，例如安装java环境：`yum -y install java-1.8.0*`

### 编译

有的软件的tar.gz压缩包，解压后，需要C语言环境进行编译

## 2、需要安装的软件

### jdk

```
yum list | grep java 查看yum源中带有java的安装包
yum -y install java-1.8.0* 安装jdk
yum安装后，自动配置jdk环境变量
```

### tomcat

1. 官网下载tomcat：https://tomcat.apache.org/download-90.cgi

2. 拷贝到linux中

3. 解压tomcat.tar.gz

4. 进入bin目录运行，startup.sh，命令：`./startup.sh`

5. 进行访问，如果无法访问，关闭防火墙或添加白名单

6. ```xml
   成功访问tomcat管理页面后，配置tomcat管理员，在conf/tomcat-users.xml中配置以下代码：
   <role rolename="manager-gui"/>
   <user username="tomcat" password="123" roles="manager-gui"/>
   ```

7. ```xml
   如果访问登录页面中manager App后，登录页面没有弹出，需要在webapps/manager/Meta-inf/context.xml添加以下代码（如果配置文件已经有相同标签需要删除）：
   <Valve className="org.apache.catalina.valves.RemoteAddrValve"
          allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|\d+\.\d+\.\d+\.\d" />
   ```

8. ![image-20210811120002719](https://gitee.com/yh-gh/img-bed/raw/master/202109181443702.png)

### mysql

1. ```bash
   #centos7的yum源中没有mysql安装包,先在linux中安装wget的命令
   yum install wget 
   ```

2. ```bash
   #再使用wget获取网络上的mysql安装包
   wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
   ```

3. ```bash
   #将mysql安装包放置到本地仓库中
   rpm -ivh mysql57-community-release-el7-9.noarch.rpm
   ```

4. ```bash
   #进入仓库运行安装mysql的代码
   cd /etc/yum.repos.d/
   yum -y install mysql-server
   ```

5. ```bash
   #启动mysql服务
   systemctl start mysqld.service
   #查看mysql是否启动
   service mysqld status
   #查看临时密码
   grep 'temporary password' /var/log/mysqld.log
   #登录mysql
   mysql -uroot -p
   ```

6. ```bash
   #设置密码策略为低，长度6位
   set global validate_password_policy=LOW;
   set global validate_password_length=6; 
   #设置密码
   ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
   ```

7. ```bash
   #给防火墙加白名单，放开3306端口或者关闭防火墙。
   firewall-cmd --zone=public --add-port=3306/tcp --permanent
   #设置远程访问权限
   grant all privileges on *.* to root@'%' identified by '1';
   flush privileges;
   ```

8. 使用windows可视化工具连接即可

# 运行jar

使用`nohup java -jar XXX.jar &`

可以保持项目运行在后台，窗口关闭不会导致项目停止，不挂断运行命令,当账户退出或终端关闭时,程序仍然运行

可以通过`ps -aux | grep "java -jar XXX.jar"`查看运行的进程

使用`kill PID号//任务的PID号`杀死进程
