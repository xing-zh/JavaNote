# ELK

ELK是ElasiticSearch+LogStash+Kibana的三合一版本

# ELK的安装

## 1、使用Docker查询镜像

```bash
docker search elk
```

![image-20210906104314778](https://gitee.com/yh-gh/img-bed/raw/master/202109181400749.png)

## 2、下载镜像

```bash
docker pull sebp/elk:700
```

## 3、查看镜像是否安装成功

```bash
docker images
```

![image-20210906115821286](https://gitee.com/yh-gh/img-bed/raw/master/202109181400653.png)

# 启动ELK

## 1、添加配置文件

```bash
echo "vm.max_map_count=262144" > /etc/sysctl.conf
```

## 2、启用配置文件

```bash
sysctl -p
```

## 3、在Docker中启动ELK镜像

```bash
docker run -dit --name elk \
-p 5601:5601 \
-p 9200:9200 \
-p 5044:5044 \
-v /root/elk/elk-data:/var/lib/elasticsearch \
-v /root/elk/elasticsearch/plugins:/opt/elasticsearch/plugins \
--privileged=true \
sebp/elk:700
```

- `-dit`：后台启动、交互式运行、tty终端
- `--name elk`：启动后容器名为elk
- `-p 5601:5601`：映射kibana访问端口
- `-p 9200:9200`：映射ES访问端口
- `-p 5044:5044`：映射logstash收集日志端口
- `-v /opt/elk-data:/var/lib/elasticsearch \`：指定ES数据目录
- `--privileged=true`：赋予容器最高的root权限

## 4、查看容器文件目录并进行kibana汉化

```bash
docker exec -it elk /bin/bash
```

`/etc/logstash/`：logstash 配置文件路径

`/etc/elasticsearch/`：ES配置文件路径

`/var/log/ `：日志路径

### 4.1、kibana汉化

进入容器后，执行命令

```bash
vi /opt/kibana/config/kibana.yml
```

在最后一行添加

```bash
i18n.locale: "zh-CN"
```

![image-20210907173238841](https://gitee.com/yh-gh/img-bed/raw/master/202109181400391.png)

保存退出，重启容器

## 5、将三个端口配置到防火墙白名单

```bash
firewall-cmd --zone=public --add-port=5601/tcp --permanent
firewall-cmd --zone=public --add-port=9200/tcp --permanent
firewall-cmd --zone=public --add-port=5044/tcp --permanent
#重启防火墙
firewall-cmd --reload
```

## 6、测试是否启动成功

### 6.2、浏览器访问`宿主机ip:9200`

![image-20210906135054582](https://gitee.com/yh-gh/img-bed/raw/master/202109181400766.png)

### 6.3、浏览器访问`宿主机ip:5601`

![image-20210906135220271](https://gitee.com/yh-gh/img-bed/raw/master/202109181400460.png)

