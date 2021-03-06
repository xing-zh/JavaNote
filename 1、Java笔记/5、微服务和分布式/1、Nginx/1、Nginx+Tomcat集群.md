# Tomcat存在的问题

1、Tomcat：一种轻量级的WEB容器，它的适用场景中小型系统或者并发量不高的系统，它是apache平台与Sun公司一起合作开发出来的，专门支持Servlet的一种WEB容器

2、Tomcat 单位时间1s范围内（默认150），一般最多可以支持到500的并发（QPS）,当超过500以后，性能将急速下降。当超过最大承受量以后，系统可能返回：Server is too Busy

## 解决方案

* 使用集群
* 集群：当单台服务器性能较低时，我们去购买更多的服务器，集中起来组成一个群体，统一对外。相同的服务集群可以提高系统的整体响应性能，以及整体的可用性
* 可用性：任何时间范围内容，系统都是正常的。按理论来说，应该是100%的时间，但是业界中，能做到99%的都不多，做的最好的：阿里 ，腾讯 （99.99%）
* 当一台服务器的处理能力、存储空间不足时，不要企图去换更强大的服务器，对大型网站而言，不管多么强大的服务器，都满足不了网站持续增长的业务需求。这种情况下，更恰当的做法是增加一台服务器分担原有服务器的访问及存储压力。扩展网络设备和服务器的带宽、增加吞吐量、加强网络数据处理能力、提高网络的灵活性和可用性。其意思就是分摊到多个操作单元上进行执行。

# Nginx概述

Nginx跟apache一样，都是HTTP服务器，但是它也有它自己的特点

1. Nginx 是一种**反向代理**服务器。也是一个IMAP/POP3/SMTP/STOMP的服务器
2. Nginx提供负载均衡功能（跟apache一样），可以HTTP服务器对外提供服务
3. 处理静态资源文件，甚至可以提供对静态资源文件的缓存
4. 支持模块化的结构配置
5. Nginx默认10K/S，每秒默认支持10000的并发量

国内很多大厂都在使用Nginx，如：百度，京东，新浪，网易，腾讯，阿里……；中小厂，就更喜欢用

## 反向代理与正向代理

- 反向代理（Reverse Proxy）
  - 从外网到内网的访问就是：反向代理
  - Nginx接收用户的请求，然后再将用户的请求转发给内部网络服务器，并从内部服务器身上得到结果，然后再把结果再转发给客户端。 此时：Nginx对于Tomcat来讲，它就是一台对外的代理服务器
- 正向代理
  - 从内网到外网的访问就是：正向代理。

## Nginx的功能

1. 处理静态资源，也可以自动索引文件
2. 反向代理，让外部可以访问内部资源，并提供多种负载均衡算法和容错机制
3. 提供基于IP和域名的虚拟主机服务
4. 提供了模拟化的结构，同一个Proxy请求的多个子请求并发处理
5. IMAP/POP3/SMTP代理服务
6. 支持FLV（Flash视频）
7. 基于客户端IP地址和HTTP基本认证的访问控制

# Nginx + Tomcat 集群架构

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181346830.gif)

* 整体思想方向：前端部署nginx服务器，后端部署tomcat应用
* 用户访问nginx服务器，对于静态资源，nginx服务器直接返回到浏览器展示给用户，对动态资源的请求被nginx服务器转发（分配）到tomcat应用服务器，tomcat应用服务器将处理后得到的数据结构返回给nginx服务器，然后返回到浏览器展示给用户

# 负载均衡机制

## 负载均衡的好处

1、多个服务器作响应

2、服务器不会宕机

3、能够对主机减少压力

## 负载均衡策略（面试题）

1、轮询（默认）

每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。 

2、指定权重

指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。 

3、IP绑定 ip_hash

每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。

4、fair（第三方）

按后端服务器的响应时间来分配请求，响应时间短的优先分配。 

5、url_hash（第三方）

按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，后端服务器为缓存时比较有效。

 