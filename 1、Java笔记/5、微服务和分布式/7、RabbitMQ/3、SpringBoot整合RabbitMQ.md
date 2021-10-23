# 准备工作

## 1、添加依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

## 2、修改配置文件

application.yml

```yml
server:
  port: 8080
spring:
  # 配置RabbitMQ服务器
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest
    listener:
      simple:
        # 手动应答
        acknowledge-mode: manual
        # 限流
        prefetch: 1
        # 最少消费者数量
        concurrency: 1
        # 最多消费者数量
        max-concurrency: 10
        # 支持重试
        retry:
          enabled: true
```

# Queue模式

## 简单模式

### 配置类

```java
@Configuration
public class RabbitConfig {
    //org.springframework.amqp.core.Queue
    @Bean
    public Queue queue(){
        return new Queue("boot_queue");
    }
}
```

### 生产者controller

```java
@RestController
public class SimpleController {
    @Resource
    private RabbitTemplate rabbitTemplate;

    @GetMapping("/producer")
    public String producer(String msg){
        //发送的对象必须实现序列化接口
        Map<String,Object> map = new HashMap<>();
        map.put("msg",msg);
        map.put("user",new User("lucy",18));
        rabbitTemplate.convertAndSend("boot_queue",map);
        return "ok";
    }
}
```

### 消费者

```java
@Component
public class SimpleConsumer {
	//接取对象的时候，使用和发送时相同的类型就可以
    @RabbitListener(queues = {"boot_queue"})
    public void consumer(Map<String,Object> map){
        System.out.println("简单模式消费者：" + map);
    }
}
```

## 工作模式

生产者与简单模式中相同

### 1、在yml配置文件中，声明手动应答和QOS限流

```yml
spring:
  rabbitmq:
    listener:
      simple:
        # 手动应答
        acknowledge-mode: manual
        # 限流
        prefetch: 1
```

### 2、消费者中，进行手动应答

```java
@Component
public class SimpleConsumer {
    @RabbitListener(queues = {"boot_queue"})
    public void consumer(Map<String,Object> map, Channel channel, Message message){
        System.out.println("简单模式消费者：" + map);
        try {
            //进行手动提交
            channel.basicAck(message.getMessageProperties().getDeliveryTag(),false);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
}
```

# Exchange模式（订阅模式）

## 路由模式（direct）

### 配置类

```java
@Configuration
public class RabbitConfig {
    @Bean
    public Queue redQueue(){
        return new Queue("redQueue");
    }
    @Bean
    public Queue greenQueue(){
        return new Queue("greenQueue");
    }
    @Bean
    public DirectExchange directExchange(){
        return new DirectExchange("directExchange");
    }
    @Bean
    public Binding bindingRed(Queue redQueue,DirectExchange directExchange){
        //将队列redQueue绑定到directExchange，路由键是red
        return BindingBuilder.bind(redQueue).to(directExchange).with("red");
    }
    @Bean
    public Binding bindingGreen(Queue greenQueue,DirectExchange directExchange){
        //将队列greenQueue绑定到directExchange，路由键是green
        return BindingBuilder.bind(greenQueue).to(directExchange).with("green");
    }
}
```

### 生产者

```java
@RestController
public class SimpleController {
    @Resource
    private RabbitTemplate rabbitTemplate;

    @GetMapping("/colorProducer")
    public String colorProducer(){
        for (int i = 0; i < 10; i++) {
            //发送消息到exchange，参数1：交换机名，参数2：路由键，参数3：消息
            rabbitTemplate.convertAndSend("directExchange","red","红色" + i);
        }
        for (int i = 0; i < 10; i++) {
            rabbitTemplate.convertAndSend("directExchange","green","绿色" + i);
        }
        return "ok";
    }
}
```

### 消费者

```java
@Component
public class SimpleConsumer {

    //声明一个消费者，接收redQueue队列消息
    @RabbitListener(queues = {"redQueue"})
    public void redConsumer(String msg,Channel channel,Message message){
        System.out.println("红色消费者：" + msg);
        try {
            channel.basicAck(message.getMessageProperties().getDeliveryTag(),false);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }

    //声明一个消费者，接收greenQueue队列消息
    @RabbitListener(queues = {"greenQueue"})
    public void greenConsumer(String msg,Channel channel,Message message){
        System.out.println("绿色消费者：" + msg);
        try {
            channel.basicAck(message.getMessageProperties().getDeliveryTag(),false);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
}
```

## 广播模式（fanout）

### 配置类

```java
@Configuration
public class RabbitConfig {
    @Bean
    public Queue queue1(){
        return new Queue("queue1");
    }
    @Bean
    public Queue queue2(){
        return new Queue("queue2");
    }
    @Bean
    public FanoutExchange fanoutExchange(){
        return new FanoutExchange("fanoutExchange");
    }
    @Bean
    public Binding bindingQueue1(Queue queue1,FanoutExchange fanoutExchange){
        //将队列queue1绑定到fanoutExchange
        return BindingBuilder.bind(queue1).to(fanoutExchange);
    }
    @Bean
    public Binding bindingQueue2(Queue queue2,FanoutExchange fanoutExchange){
        //将队列queue2绑定到fanoutExchange
        return BindingBuilder.bind(queue2).to(fanoutExchange);
    }
}
```

### 生产者

```java
@RestController
public class SimpleController {
    @Resource
    private RabbitTemplate rabbitTemplate;
    
    @GetMapping("/fanoutProducer")
    public String fanoutProducer(){
        for (int i = 0; i < 10; i++) {
            //发送消息到exchange，参数1：交换机名，参数2：路由键，参数3：消息
            rabbitTemplate.convertAndSend("fanoutExchange","","广播模式：" + i);
        }
        return "ok";
    }
}
```

### 消费者

```java
@Component
public class SimpleConsumer {
    //声明一个消费者，接收queue1队列消息
    @RabbitListener(queues = {"queue1"})
    public void queue1Consumer(String msg,Channel channel,Message message){
        System.out.println("queue1：" + msg);
        try {
            channel.basicAck(message.getMessageProperties().getDeliveryTag(),false);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
    //声明一个消费者，接收queue2队列消息
    @RabbitListener(queues = {"queue2"})
    public void queue2Consumer(String msg,Channel channel,Message message){
        System.out.println("queue2：" + msg);
        try {
            channel.basicAck(message.getMessageProperties().getDeliveryTag(),false);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
}
```

## 主题模式（topic）

### 配置类

```java
@Configuration
public class RabbitConfig {
    @Bean
    public Queue queueXian(){
        return new Queue("queueXian");
    }
    @Bean
    public Queue queueBeijing(){
        return new Queue("queueBeijing");
    }
    @Bean
    public TopicExchange topicExchange(){
        return new TopicExchange("topicExchange");
    }
    @Bean
    public Binding bindingXian(Queue queueXian,TopicExchange topicExchange){
        //将队列redQueue绑定到directExchange，路由键是red
        return BindingBuilder.bind(queueXian).to(topicExchange).with("*.xian");
    }
    @Bean
    public Binding bindingBeijing(Queue queueBeijing,TopicExchange topicExchange){
        //将队列greenQueue绑定到directExchange，路由键是green
        return BindingBuilder.bind(queueBeijing).to(topicExchange).with("*.beijing");
    }
}
```

### 生产者

```java
@RestController
public class SimpleController {
    @Resource
    private RabbitTemplate rabbitTemplate;

    @GetMapping("/topicProducer")
    public String topicProducer(){
        for (int i = 0; i < 10; i++) {
            rabbitTemplate.convertAndSend("topicExchange","order.xian","西安订单" + i);
        }
        for (int i = 0; i < 10; i++) {
            rabbitTemplate.convertAndSend("topicExchange","order.beijing","北京订单" + i);
        }
        for (int i = 0; i < 10; i++) {
            rabbitTemplate.convertAndSend("topicExchange","back.xian","西安退货" + i);
        }
        for (int i = 0; i < 10; i++) {
            rabbitTemplate.convertAndSend("topicExchange","order.beijing","北京退货" + i);
        }
        return "ok";
    }
}
```

### 消费者

```java
@Component
public class SimpleConsumer {
    //声明一个消费者，接收队列queueXian队列消息
    @RabbitListener(queues = {"queueXian"})
    public void queueXianConsumer(String msg,Channel channel,Message message){
        System.out.println("西安仓：" + msg);
        try {
            channel.basicAck(message.getMessageProperties().getDeliveryTag(),false);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
    //声明一个消费者，接收队列queueBeijing队列消息
    @RabbitListener(queues = {"queueBeijing"})
    public void queueBeijingConsumer(String msg,Channel channel,Message message){
        System.out.println("北京仓：" + msg);
        try {
            channel.basicAck(message.getMessageProperties().getDeliveryTag(),false);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
}
```

# 死信、延迟队列

## 死信队列

### 死信生成的三个条件

- 消息被拒绝(basic.reject / basic.nack)，并且requeue = false
- 消息TTL过期
- 队列达到最大长度

### 模拟消息丢失

```java
public class Producer {
    public static final String QUEUE_NAME = "normalQueue";
    public static final String EXCHANGE_NAME = "normalExchange";
    public static void main(String[] args) throws IOException, TimeoutException {
        Connection connection = ConnectionUtils.getConnection();
        Channel channel = connection.createChannel();
        channel.exchangeDeclare(EXCHANGE_NAME,"fanout");
        Map<String,Object> map = new HashMap<>();
        map.put("x-max-length",25);
        channel.queueDeclare(QUEUE_NAME, false, false, false, map);
        for (int i = 0; i < 100; i++) {
            String message = "hello rabbitmq world!!"+i;
            channel.basicPublish("",QUEUE_NAME,null,message.getBytes());
        }

        System.out.println("send ok!");
        connection.close();
    }
}
```

![image-20210903100004889](https://gitee.com/yh-gh/img-bed/raw/master/202109181357110.png)

### 通过死信队列接收这75条消息

```java
public class Producer {
    public static final String QUEUE_NAME = "normalQueue";
    public static final String EXCHANGE_NAME = "normalExchange";
    public static void main(String[] args) throws IOException, TimeoutException {
        Connection connection = ConnectionUtils.getConnection();
        Channel channel = connection.createChannel();

        channel.exchangeDeclare(EXCHANGE_NAME,"fanout");
        Map<String,Object> map = new HashMap<>();
        map.put("x-max-length",25);	//生成死信
        map.put("x-dead-letter-exchange","deadExchange"); //产生死信时发到哪个交换机上
        map.put("x-dead-letter-routing-key","deadletter"); //声明routingkey
        channel.queueDeclare(QUEUE_NAME, false, false, false, map);
        channel.queueBind(QUEUE_NAME,EXCHANGE_NAME,"");


        channel.exchangeDeclare("deadExchange","direct");
        channel.queueDeclare("deadQueue",false,false,false,null);
        channel.queueBind("deadQueue","deadExchange","deadletter");

        for (int i = 0; i < 100; i++) {
            String message = "hello rabbitmq world!!"+i;
            channel.basicPublish("",QUEUE_NAME,null,message.getBytes());
        }

        System.out.println("send ok!");
        connection.close();
    }
}
```

![image-20210903100913829](https://gitee.com/yh-gh/img-bed/raw/master/202109181357911.png)

## 延迟队列

延迟队列是一个特殊的死信队列

1、按存活时间过期进入死信队列

2、普通消息没有消费者处理

### 插件实现

在rabbitmq 3.5.7及以上的版本提供了一个插件（rabbitmq-delayed-message-exchange）来实现延迟队列功能。同时插件依赖Erlang/OPT 18.0及以上。

### 1、下载

https://www.rabbitmq.com/community-plugins.html

### 2、安装

插件格式为ez，将文件复制到插件目录plugins

### 3、启动插件

```bash
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

![image-20210201172837847](https://gitee.com/yh-gh/img-bed/raw/master/202109181357852.png)

### 4、查看

![image-20210201172954307](https://gitee.com/yh-gh/img-bed/raw/master/202109181357774.png)

### 5、main方法实现

#### 依赖

```xml
<dependency>
    <groupId>com.rabbitmq</groupId>
    <artifactId>amqp-client</artifactId>
    <version>5.9.0</version>
</dependency>
```

#### 生产者

```java
public class Send {
    static final String exchangeName = "test_exchange";
    static final String queueName = "test_queue";
    static final String routingKey = "test_queue";

    public static void main(String[] args) throws IOException, TimeoutException {
        //建立连接，创建通道
        ConnectionFactory fc = new ConnectionFactory();
        fc.setHost("192.168.2.100");
        fc.setPort(5672);
        fc.setUsername("guest");
        fc.setPassword("guest");

        Connection conn = fc.newConnection();
        Channel channel = conn.createChannel();

        //配置交换机类型
        Map<String, Object> map = new HashMap<>();
        map.put("x-delayed-type", "direct");
        //创建路由
        channel.exchangeDeclare(exchangeName, "x-delayed-message",false, false,map);  
		//创建队列
        channel.queueDeclare(queueName, true, false, false, null);  
        //绑定路由、队列
        channel.queueBind(queueName, exchangeName, routingKey);  

        
        String msg = "延时消息";
        //配置延时时间
        AMQP.BasicProperties.Builder builder = new AMQP.BasicProperties.Builder();
        Map headers = new HashMap();
        headers.put("x-delay", 9000);
        builder.headers(headers);
        AMQP.BasicProperties  properties = builder.build();
		//发送消息
        channel.basicPublish(exchangeName, queueName, properties, msg.getBytes());

        channel.close();
        conn.close();
    }
}
```

#### 消费者和以前相同

### 6、Boot实现

#### 依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
    <version>2.4.2</version>
</dependency>
```

#### 配置文件和之前一样

#### 配置类

```java
@Configuration
public class RabbitMQConfig {
    public static final String exchangeName = "test_exchange";
    public static final String queueName = "test_queue";
    public static final String routingKey = "test_queue";
    /**
     * 创建延迟队列
     */
    @Bean
    public Queue createQueue(){
        return QueueBuilder.durable(queueName).build();
    }
    /**
     * 创建路由
     */
    @Bean
    public CustomExchange createExchange(){
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("x-delayed-type", "direct");
        return new CustomExchange(
                exchangeName, "x-delayed-message", true, false, map);
    }
    /**
     * 绑定路由与队列
     */
    @Bean
    public Binding exchangeBindingQueue(){
        return BindingBuilder.bind(createQueue()).
                to(createExchange()).with(routingKey).noargs();
    }
}
```

#### 生产者

```java
/**
 * 延迟消息 发布者
 */
@RestController
public class SendController {
    @Autowired
    RabbitTemplate rabbitTemplate;

    @GetMapping("/send")
    public String sendMsg(){
        String msg = "测试延时消息|"+LocalDateTime.now();
        //ES6
        rabbitTemplate.convertAndSend(RabbitMQConfig.exchangeName, RabbitMQConfig.routingKey, msg, (message) ->{
            message.getMessageProperties().setHeader("x-delay", 9000); //延迟9秒
            return message;
        });
        return "发送消息成功！";
    }
}
```

#### 消费者和之前一样
