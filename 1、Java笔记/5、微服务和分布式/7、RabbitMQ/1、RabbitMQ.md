#  消息队列

- MQ是消息队列服务器，产品：ActiveMQ，RabbitMQ，RocketMQ，Kafka……

- 消息队列（Message Queue，简称MQ），从字面意思上看，本质是个队列，FIFO先入先出，只不过队列中存放的内容是message而已
- RabbitMQ是一个由erlang开发的基于AMQP（Advanced Message Queue Protocol）协议的开源实现。用于在分布式系统中存储转发消息，在易用性、扩展性、高可用性等方面都非常的优秀。是当前最主流的消息中间件之一

# 应用场景

## 1、异步处理

当用户注册，给邮箱和手机都发送验证信息

用户注册需要50ms、发邮箱需要50ms、发手机需要50ms，总共需要150ms

用户注册后、将发邮箱和发手机都放到消息队列中，可以通过消息队列进行异步处理,总共可以节省50ms

## 2、程序解耦

多应用间通过消息队列对同一消息进行处理，避免调用接口失败导致整个过程失败

## 3、限流削峰

广泛应用于秒杀或抢购活动中，避免流量过大导致应用系统挂掉的情况

# RabbitMQ选型和对比

## 1.从社区活跃度 

按照目前网络上的资料，`RabbitMQ` 、`activeM` 、`ZeroMQ` 三者中，综合来看，`RabbitMQ` 是首选。 

## 2.持久化消息比较

`ZeroMq` 不支持，`ActiveMq` 和`RabbitMq` 都支持。持久化消息主要是指我们机器在不可抗力因素等情况下挂掉了，消息不会丢失的机制。

## 3.综合技术实现

可靠性、灵活的路由、集群、事务、高可用的队列、消息排序、问题追踪、可视化管理工具、插件系统等等。

`RabbitMq` / `Kafka` 最好，`ActiveMq` 次之，`ZeroMq` 最差。当然`ZeroMq` 也可以做到，不过自己必须手动写代码实现，代码量不小。尤其是可靠性中的：持久性、投递确认、发布者证实和高可用性。

## 4.高并发

毋庸置疑，`RabbitMQ` 最高，原因是它的实现语言是天生具备高并发高可用的`erlang` 语言。

## 5.比较关注的比较， RabbitMQ 和 Kafka

`RabbitMq` 比`Kafka` 成熟，在可用性上，稳定性上，可靠性上，RabbitMQ胜于 Kafka（理论上）。

另外，`Kafka` 的定位主要在日志等方面， 因为`Kafka` 设计的初衷就是处理日志的，可以看做是一个日志（消息）系统一个重要组件，针对性很强，所以 如果业务方面还是建议选择 `RabbitMq` 。

还有就是，`Kafka` 的性能（吞吐量、`TPS` ）比`RabbitMq` 要高出来很多。

# 安装配置

## 1、Erlang的安装及配置

### 1.1、下载

下载网址：http://www.erlang.org/downloads

![image-20210901102845523](https://gitee.com/yh-gh/img-bed/raw/master/202109181355679.png)

选择自己的安装目录，全程下一步

### 1.2、配置环境变量

![image-20210901103048157](https://gitee.com/yh-gh/img-bed/raw/master/202109181355276.png)

配置path，为`ERLANG_HOME\bin`

![image-20210901103225007](https://gitee.com/yh-gh/img-bed/raw/master/202109181355662.png)

### 1.3、查看配置是否成功

cmd下输入erl

![image-20210901103331334](https://gitee.com/yh-gh/img-bed/raw/master/202109181355924.png)

## 2、RabbitMQ的安装及配置

### 2.1、下载RabbitMQ

下载网址：http://www.rabbitmq.com/download.html

![image-20210901103453924](https://gitee.com/yh-gh/img-bed/raw/master/202109181355084.png)

### 2.2、安装RabbitMQ

双击安装包，全程下一步

### 2.3、安装RabbitMQ-Plugins

进入RabbitMQ的sbin目录，打开cmd

执行命令：`rabbitmq-plugins enable rabbitmq_management`

![image-20210901104904852](https://gitee.com/yh-gh/img-bed/raw/master/202109181355741.png)

### 2.4、配置RabbitMQ环境变量

![image-20210901105517697](https://gitee.com/yh-gh/img-bed/raw/master/202109181355391.png)

path环境变量中添加：`%RABBITMQ_HOME%\sbin;`

## 3、启动RabbitMQ服务

- cmd输入命令
  - 开启服务
    - net start RabbitMQ
  - 关闭服务
    - net stop RabbitMQ

### 如果启动报错

管理员运行cmd

1、执行命令：`rabbitmq-service.bat remove`

2、在RabbitMq任意路径下，建立目录data

3、执行命令，路径改为刚才创建的名录：`set RABBITMQ_BASE=D:\rabbitmq_server\data`

4、执行命令：`rabbitmq-service.bat install`

5、执行命令：`rabbitmq-plugins enable rabbitmq_management`

6、在管理服务中启动服务就可以了、启动输入命令：`services.msc`

### 启动成功

![image-20210901120926124](https://gitee.com/yh-gh/img-bed/raw/master/202109181355277.png)

## 4、访问RabbitMQ登录页面

http://localhost:15672

初始的账号密码都是：guest

![image-20210901111118250](https://gitee.com/yh-gh/img-bed/raw/master/202109181356846.png)

### 登录监控平台

![image-20210901114702273](https://gitee.com/yh-gh/img-bed/raw/master/202109181356149.png)

## Linux下安装

### 获取RabbitMQ的镜像

- `docker pull daocloud.io/library/rabbitmq:3.7.26-management`

### 启动RabbitMQ容器

- `docker run -d --net=host --name some-rabbit --privileged=true daocloud.io/library/rabbitmq:3.7.26-management`
- 开启完毕之后，会暴露2大端口

- - 5672：数据访问端口
  - 15672：监控平台端口

- - --net=host：主动暴露端口 （也可以使用-p 一个一个的做映射）

- 如果没有关闭防火墙，请暴露端口

- - `firewall -cmd --permanent --add-port=5672/tcp --permanent`
  - `firewall -cmd --permanent --add-port=15672/tcp --permanent`

- - `firewall -cmd --reload`

# 应用中的问题

# 系统架构

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181356508.jpeg)

- producer&Consumer  
  - p指的是消息生产者，c指消息的消费者
- Queue：消息队列
  - 提供了FIFO的处理机制，具有缓存消息的能力。rabbitmq中，队列消息可以设置为持久化，临时或者自动删除。
  - 设置为持久化的队列，queue中的消息会在server本地硬盘存储一份，防止系统crash，数据丢失
  - 设置为临时队列，queue中的数据在系统重启之后就会丢失
  - 设置为自动删除的队列，当不存在用户连接到server，队列中的数据会被自动删除
- Exchange：消息交换机
  - Exchange类似于数据通信网络中的交换机，提供消息路由策略。rabbitmq中，producer不是通过信道直接将消息发送给queue，而是先发送给Exchange。
  - 一个Exchange可以和多个Queue进行绑定，producer在传递消息的时候，会传递一个ROUTINGKEY，Exchange会根据这个ROUTINGKEY按照特定的路由算法，将消息路由给指定的queue。
  - 和Queue一样，Exchange也可设置为持久化，临时或者自动删除。 
- Binding：绑定
  - 它的作用就是把exchange和queue按照路由规则绑定起来.
- Routing Key：路由关键字
  - exchange根据这个关键字进行消息投递。 
- Channel：消息通道
  - 在客户端的每个连接里，可建立多个channel
  - 信道是生产消费者与rabbit通信的渠道，生产者publish或者消费者消费一个队列都是需要通过信道来通信的。
  - 信道是建立在TCP上面的虚拟链接，也就是rabbitMQ在一个TCP上面建立成百上千的信道来达到多个线程处理。
  - 注意是一个TCP 被多个线程共享，每个线程对应一个信道，信道在rabbit都有唯一的ID，保证了信道的私有性，对应上唯一的线程使用。

