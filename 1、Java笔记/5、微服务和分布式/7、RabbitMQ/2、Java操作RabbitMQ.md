# 准备工作

## 1、查看数据端口，默认5672

![image-20210901121611491](https://gitee.com/yh-gh/img-bed/raw/master/202109181356428.png)

## 2、导入依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
```

## 3、编写连接工具类

```java
/**
 * 连接工具类
 */
public class ConnectionUtil {

    /**
     * RabbitMQ的工具方法
     */
    public static Connection getConnection() throws IOException, TimeoutException {
        ConnectionFactory factory = new ConnectionFactory();
        //主机ip
        factory.setHost("localhost");
        //数据端口，默认5672
        factory.setPort(5672);
        //账号，默认guest
        factory.setUsername("guest");
        //密码，默认guest
        factory.setPassword("guest");
        return factory.newConnection();
    }
}
```

- RabbitMQ提供了2种通讯方式：Queue模式（点对点），发布/订阅模式

# Queue模式

## 简单模式（1v1）

- 队列模式：跳过交换机，消息的发布者与消费者直接通过队列进行消息的交互
- P是我们的生产者，C是我们的消费者。中间的框是一个队列——RabbitMQ代表消费者保存的消息缓冲区

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181356068.jpeg)

### 生产者

```java
public class MyTest {
    public static final String QUEUE_NAME = "testQueue";
    /**
     * 消息的生产者
     */
    @Test
    public void producer(){
        Connection connection = null;
        try {
            //一、获取连接对象
            connection = ConnectionUtil.getConnection();
            //二、创建一个消息传输通道
            Channel channel = connection.createChannel();
            /*
             * 三、定义一个队列
             * 1、队列的名称
             * 2、重启RabbitMQ时候，是否需要删除该队列(持久化)
             * 3、队列是否只能被该连接所独占
             * 4、队列在没有连接使用的情况，是否需要删除
             * 5、附加参数，一般设置为null
             */
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            String msg = "Hello RabbitMQ!!!";
            for (int i = 0; i < 20; i++) {
                msg += i;
                //四、发送消息
                channel.basicPublish("",QUEUE_NAME,null,msg.getBytes());
            }
            System.out.println("发送完毕");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

执行后可以发现队列中，有二十个消息

![image-20210901142243553](https://gitee.com/yh-gh/img-bed/raw/master/202109181356917.png)

### 消费者

```java
public class MyConsumer {
    public static final String QUEUE_NAME = "testQueue";
    public static void main(String[] args) {
        Connection connection = null;
        try{
            //一、获取连接
            connection = ConnectionUtil.getConnection();
            //二、创建一个消息传输通道
            Channel channel = connection.createChannel();
            /*
             * 定义一个队列
             * 1、队列的名称
             * 2、重启RabbitMQ时候，是否需要删除该队列(持久化)
             * 3、队列是否只能被该连接所独占
             * 4、队列在没有连接使用的情况，是否需要删除
             * 5、附加参数，一般设置为null
             */
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            //三、声明一个消费者，定义规则
            Consumer consumer = new DefaultConsumer(channel){
                /**
                 * 处理MQ交付过来的数据
                 * @param consumerTag
                 * @param envelope
                 * @param properties
                 * @param body 传递过来的数据
                 * @throws IOException
                 */
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println(new String(body, "UTF-8"));
                    // 手动提交
                    channel.basicAck(envelope.getDeliveryTag(), false);
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            };
            /**
             * 四、进行消费
             * 自动确认true
             * 手动确认false  channel.basicAck(envelope.getDeliveryTag(),false);
             */
            channel.basicConsume(QUEUE_NAME, false, consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

## 工作模式（能者多劳work）

- 上一个例子是一对一发送接收形式，而工作队列为一对多发送接收形式
- 工作队列（即任务队列）背后的主要思想是避免立即执行资源密集型任务，并且必须等待它完成。相反，我们把任务安排在以后做

- 我们将任务封装为消息并将其发送到队列。在后台运行的工作进程会弹出任务并最终执行任务。当你运行许多Consumer时，任务将在他们之间共享，如下图

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181356604.jpeg)

### 简单模式的多个消费者存在的问题

1、消息会被一次性拿走，如果在消费者消费的过程中，消费者的服务器发生了宕机，那么会造成消息的丢失

2、多个消费者存在的情况，消息是被平分的，所以每个消费者拿到的消息是相同的，会导致效率高的消费者消费完以后无事可做

### 解决方法

解决第一个问题，可以使用手动应答（简单模式代码已经实现）

```java
//所有消费者第二个参数，改为false
channel.basicConsume(QUEUE_NAME, false, consumer);
/*
 * 在重写的handleDelivery方法中，每处理完一个消息，进行手动应答
 * 第一个参数为消息的下标
 * 第二个参数为false：只确认当前消息；true：确认当前消息以及之前的消息
 */
channel.basicAck(envelope.getDeliveryTag(),false);
```

解决第二个问题，可以使用QOS限流

```java
//参数限制了，当前消费者，每次可以拉去1个消息
channel.basicQos(1);
```

### 消费者代码示例

```java
public class Consumer1 {
    public static void main(String[] args) {
        Connection connection = null;
        try {
            //获取连接
            connection = ConnectionUtil.getConnection();
            //创建数据通道
            Channel channel = connection.createChannel();
            //队列声明
            channel.queueDeclare(MyTest.QUEUE_NAME,false,false,false,null);
            //进行限流
            channel.basicQos(1);
            //声明一个消费者，进行消费
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    try {
                        Thread.sleep(2000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println("消费者1：" + new String(body,"utf8"));
                    //进行手动提交
                    channel.basicAck(envelope.getDeliveryTag(), false);
                }
            };
            //启动消费，并且关闭自动提交
            channel.basicConsume(MyTest.QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

# exchange模式（订阅模式）

## direct交换机（路由模式）

如下图，在这个设置中，我们可以看到与它绑定的两个队列的直接交换X。第一个队列绑定了绑定键橙色，第二个队列有两个绑定，一个绑定键为黑色，另一个为绿色。在这样的设置中，将发送到与路由键橙色的交换的消息将被路由到队列Q1。带有黑色或绿色的路由键的消息将会进入Q2，所有其他消息将被丢弃



![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181356220.jpeg)

### 生产者

```java
public class Producer {
    //交换机名称，生产者只针对于交换机
    public static final String EXCHANGE_NAME = "direc_exchange";

    public static void main(String[] args) {
        Connection connection = null;
        try{
            //获取连接对象
            connection = ConnectionUtil.getConnection();
            //获取消息通道
            Channel channel = connection.createChannel();
            /*
             * 给通道u交换机
             * 第1个参数：交换机的名称
             * 第2个参数：交换机的类型 direct
             */
            channel.exchangeDeclare(EXCHANGE_NAME,"direct");
            for (int i = 0; i < 100; i++) {
                //不同情况，生成不同的路由键
                String routerKey = "";
                if (i < 30){
                    routerKey = "orange";
                }else if (i > 70){
                    routerKey = "black";
                }else {
                    routerKey = "green";
                }
                //发送消息到交换机
                String msg = "Hello direct!!!" + i;
                channel.basicPublish(EXCHANGE_NAME,routerKey,null,msg.getBytes());
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

### 消费者1

```java
public class Consumer1 {
    public static final String QUEUE_NAME = "con1";

    public static void main(String[] args) {
        Connection connection = null;
        try{
            //获取连接对象
            connection = ConnectionUtil.getConnection();
            //获取消息通道
            Channel channel = connection.createChannel();
            //声明队列
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            //声明交换机
            channel.exchangeDeclare(Producer.EXCHANGE_NAME,"direct");
            //绑定队列和交换机之间的关系,可以声明多次，绑定多个关系
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"orange");
            //定义消费者
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println("消费者1：" + new String(body,"utf8"));
                    //手动提交
                    channel.basicAck(envelope.getDeliveryTag(),false);
                }
            };
            //进行消费
            channel.basicConsume(QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

### 消费者2

```java
public class Consumer2 {
    public static final String QUEUE_NAME = "con2";

    public static void main(String[] args) {
        Connection connection = null;
        try {
            connection = ConnectionUtil.getConnection();
            Channel channel = connection.createChannel();
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            channel.exchangeDeclare(Producer.EXCHANGE_NAME,"direct");
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"black");
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"green");
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println("消费者2：" + new String(body,"utf8"));
                    channel.basicAck(envelope.getDeliveryTag(),false);
                }
            };
            channel.basicConsume(QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

## fanout交换机（广播模式）

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181356669.jpg)

- 广播模式：发布者将消息通过交换机，直接发布到所有的与该交换机进行绑定了的队列身上
- 广播模式是没有路由键的，队列与交换机直接绑定
- 此模式下，每一个队列都会收到同样的所有的消息

### 生产者

```java
public class Producer {
    public static final String EXCHANGE_NAME = "fanout_exchange";

    public static void main(String[] args) {
        Connection connection = null;
        try{
            //获取连接对象
            connection = ConnectionUtil.getConnection();
            //获取消息通道
            Channel channel = connection.createChannel();
            //声明交换机
            channel.exchangeDeclare(EXCHANGE_NAME,"fanout");
            for (int i = 0; i < 100; i++) {
                String msg = "Hello fanout!!!" + i;
                //发送消息,没有路由键
                channel.basicPublish(EXCHANGE_NAME,"",null,msg.getBytes());
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

### 消费者1

```java
public class Consumer1 {
    public static final String QUEUE_NAME = "con1";

    public static void main(String[] args) {
        Connection connection = null;
        try {
            //获取连接
            connection = ConnectionUtil.getConnection();
            //获取消息通道
            Channel channel = connection.createChannel();
            //声明队列
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            //声明交换机
            channel.exchangeDeclare(Producer.EXCHANGE_NAME,"fanout");
            //绑定交换机和队列的关系，没有路由键
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"");
            //定义消费者
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println("消费者1：" + new String(body,"utf8"));
                    //手动提交
                    channel.basicAck(envelope.getDeliveryTag(),false);
                }
            };
            //开启消费
            channel.basicConsume(QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

### 消费者2

```java
public class Consumer2 {
    public static final String QUEUE_NAME = "con2";

    public static void main(String[] args) {
        Connection connection = null;
        try {
            connection = ConnectionUtil.getConnection();
            Channel channel = connection.createChannel();
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            channel.exchangeDeclare(Producer.EXCHANGE_NAME,"fanout");
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"");
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println("消费者2：" + new String(body,"utf8"));
                    channel.basicAck(envelope.getDeliveryTag(),false);
                }
            };
            channel.basicConsume(QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

## topic交换机（主题模式）

可以理解为Routing的通配符模式，就是将路由模式中消费者的路由键替换为使用通配符的路由键

如果两个消费者队列绑定的路由键都匹配的情况下，那么exchange会将这个消息同样发送到两个queue

- 通配符
  - `#`：可以用来表示一个或多个单词
  - `*`：可以用来表示一个单词

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181356718.jpeg)

### 生产者

模拟发送不同的消息，西安的订单、退货，北京的订单、退货，以不同的路由键发送

```java
public class Producer {
    public static final String EXCHANGE_NAME = "topic_exchange";

    public static void main(String[] args){
        Connection connection = null;
        try{
            connection = ConnectionUtil.getConnection();
            Channel channel = connection.createChannel();
            channel.exchangeDeclare(EXCHANGE_NAME,"topic");
            for (int i = 0; i < 10; i++) {
                String msg = "西安的订单" + i;
                channel.basicPublish(EXCHANGE_NAME,"order.xian",null,msg.getBytes());
            }
            for (int i = 0; i < 10; i++) {
                String msg = "北京的订单" + i;
                channel.basicPublish(EXCHANGE_NAME,"order.beijing",null,msg.getBytes());
            }
            for (int i = 0; i < 10; i++) {
                String msg = "西安的退货" + i;
                channel.basicPublish(EXCHANGE_NAME,"back.xian",null,msg.getBytes());
            }
            for (int i = 0; i < 10; i++) {
                String msg = "北京的退货" + i;
                channel.basicPublish(EXCHANGE_NAME,"back.beijing",null,msg.getBytes());
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            try {
                connection.close();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }
    }
}
```

### 消费者西安

只处理路由键为`*.xian`的订单以及退货

```java
public class ConsumerXian {
    public static final String QUEUE_NAME = "xian";

    public static void main(String[] args) {
        Connection connection = null;
        try {
            connection = ConnectionUtil.getConnection();
            Channel channel = connection.createChannel();
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            channel.exchangeDeclare(Producer.EXCHANGE_NAME,"topic");
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"*.xian");
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println("西安仓：" + new String(body,"utf8"));
                    channel.basicAck(envelope.getDeliveryTag(),false);
                }
            };
            channel.basicConsume(QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

### 消费者北京

只处理路由键为`*.beijing`的订单以及退货

```java
public class ConsumerBeijing {
    public static final String QUEUE_NAME = "beijing";

    public static void main(String[] args) {
        Connection connection = null;
        try {
            connection = ConnectionUtil.getConnection();
            Channel channel = connection.createChannel();
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            channel.exchangeDeclare(Producer.EXCHANGE_NAME,"topic");
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"*.beijing");
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println("北京仓：" + new String(body,"utf8"));
                    channel.basicAck(envelope.getDeliveryTag(),false);
                }
            };
            channel.basicConsume(QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

### 消费者总部

只处理路由键为`back.#`的所有的退货消息，exchange中`back.#`路由键的消息，除了按照后缀发送到西安、北京消费者queue以外，还会发送到总部的queue

```java
public class ConsumerZongbu {
    public static final String QUEUE_NAME = "zongbu";

    public static void main(String[] args) {
        Connection connection = null;
        try {
            connection = ConnectionUtil.getConnection();
            Channel channel = connection.createChannel();
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);
            channel.exchangeDeclare(Producer.EXCHANGE_NAME,"topic");
            channel.queueBind(QUEUE_NAME,Producer.EXCHANGE_NAME,"back.#");
            Consumer consumer = new DefaultConsumer(channel){
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    System.out.println("总部处理：" + new String(body,"utf8"));
                    channel.basicAck(envelope.getDeliveryTag(),false);
                }
            };
            channel.basicConsume(QUEUE_NAME,false,consumer);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```

# 配置

## 队列queue配置

在声明队列的时候，可以对队列进行配置

```java
/*
 * 可选参数
 * x-max-length 队列最大允许的消息数
 * x-expires 队列的自动删除时间
 * x-message-ttl 消息存活时间
 */
Map<String,String> map = new HashMap<>();
map.put("x-max-length",35);
//声明队列，在第五个参数，Map类型
channel.queueDeclare(QUEUE_NAME,false,false,false,map);
```

# 消息确认机制

## 消费者确认

就是改为手动应答，在每次处理完消息后，手动进行确认

```java
//所有消费者第二个参数，改为false
channel.basicConsume(QUEUE_NAME, false, consumer);
/*
 * 在重写的handleDelivery方法中，每处理完一个消息，进行手动应答
 * 第一个参数为消息的下标
 * 第二个参数为false：只确认当前消息；true：确认当前消息以及之前的消息
 */
channel.basicAck(envelope.getDeliveryTag(),false);
```

## 生产者确认

保证消息已经发送到exchange或queue

### 方式一：添加事务

```java
//开启事务
channel.txSelect();
//发送消息
channel.basicPublish(exchangeName,routingKey, MessageProperties, msg.getBytes());
//提交事务
channel.txCommit();
//回滚事务，如果多次提交消息的话，那么多次提交具有原子性，要么都提交，要么都不提交
channel.txRollback();
```

### 方式二：confirm

#### 1、普通confirm模式

publish一条消息后，等待服务器端confirm,如果服务端返回false或者超时时间内未返回，客户端进行消息重传。

```java
//开启发送方确认模式
channel.confirmSelect();
//发送消息
channel.basicPublish(exchangeName,routingKey, MessageProperties, msg.getBytes());
//服务器确认消息是否发送成功
if(channel.waitForConfirms()) {
    System.out.println("发送成功");
}else {
    System.out.println("发送失败");
}
```

#### 2、批量Confirm模式

使用同步方式等所有的消息发送之后才会执行后面代码，只要有一个消息未被确认就会抛出IOException异常

```java
//开启发送方确认模式
channel.confirmSelect();
//发送消息
channel.basicPublish(exchangeName,routingKey, MessageProperties, msg.getBytes());
//直到所有信息都发布，只要有一个未确认就会IOException
channel.waitForConfirmsOrDie();
```

#### 3、异步Confirm模式

异步模式的优点，就是执行效率高，不需要等待消息执行完，只需要监听消息即可

```java
//开启发送方确认模式
channel.confirmSelect();
//开启异步监听
channel.addConfirmListener(new ConfirmListener() {
    //消息未确认执行该方法
    public void handleNack(long deliveryTag, boolean multiple) throws IOException {
        // TODO Auto-generated method stub
        System.out.println("消息未确认"+deliveryTag);
    }
    //消息已确认执行该方法
    public void handleAck(long deliveryTag, boolean multiple) throws IOException {
        // TODO Auto-generated method stub
        System.out.println("消息已经确认"+deliveryTag+" "+multiple);
    }
});
//发送消息
channel.basicPublish(exchangeName,routingKey, MessageProperties, msg.getBytes());
```



