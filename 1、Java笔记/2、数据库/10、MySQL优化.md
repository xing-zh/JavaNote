# Mysql的逻辑架构

<img src="https://gitee.com/yh-gh/img-bed/raw/master/202109181209579.png" alt="img" style="zoom:;" />

## 四层逻辑架构

- 连接层
  - 主要完成一些类似连接处理，授权认证及相关的安全方案
  - 连接管理与安全性
    - 每个客户端连接都会在服务器进程中拥有一个线程，每一个连接的查询只会在这个单独的线程中执行，该线程轮流在某个CPU核心或者CPU中运行。服务器负责缓存线程。不需要为每一个新建的连接创建或者销毁线程。MySQL5.5版本之后，支持线程池插件，可以使用线程池当中少量的线程来服务大量的连接
    - 当客户端（应用）连接到MySQL服务器时，服务器需要对其进行认证。认证基于用户名、原始主机信息和密码。一旦客户端连接成功，服务器会继续验证该客户端是否具有执行某个特定查询的权限（是否允许对某个表执行SELECT语句）
- 服务层
  - 在 MySQL据库系统处理底层数据之前的所有工作都是在这一层完成的，包括权限判断，SQL接口，SQL解析，SQL分析优化， 缓存查询的处理以及部分内置函数执行(如日期,时间,数学运算,加密)等等。各个存储引擎提供的功能都集中在这一层，如存储过程，触发器，视图等
  - SQL Interface-SQL接口
    - 接受用户的SQL命令，并且返回用户需要查询的结果。比如select from就是调用SQL Interface
  - Parser-解析器
    - SQL命令传递到解析器的时候会被解析器验证和解析。解析器是由Lex和YACC实现的，是一个很长的脚本
  - Optimizer-查询优化器
    - SQL语句在查询之前会使用查询优化器对查询进行优化。就是优化客户端请求的 query（sql语句），根据客户端请求的 query 语句，和数据库中的一些统计信息，在一系列算法的基础上进行分析，得出一个最优的策略，告诉后面的程序如何取得这个 query 语句的结果
  - Cache和Buffer-查询缓存
    - 他的主要功能是将客户端提交 给MySQL 的 Select 类 query 请求的返回结果集 cache 到内存中，与该 query 的一个 hash 值做一个对应。该 Query 所取数据的基表发生任何数据的变化之后， MySQL 会自动使该 query 的Cache 失效。在读写比例非常高的应用系统中， Query Cache 对性能的提高是非常显著的。当然它对内存的消耗也是非常大的
- 引擎层
  - 是底层数据存取操作实现部分，由多种存储引擎共同组成。真正负责MySQL中数据的存储和提取。就像Linux众多的文件系统 一样。每个存储引擎都有自己的优点和缺陷。服务器是通过存储引擎API来与它们交互的。这个接口隐藏 了各个存储引擎不同的地方。对于查询层尽可能的透明。这个API包含了很多底层的操作。如开始一个事物，或者取出有特定主键的行。存储引擎不能解析SQL，互相之间也不能通信。仅仅是简单的响应服务器 的请求
- 存储层
  - 将数据存储于裸设备的文件系统之上，完成与存储引擎的交互

# MySQL存储引擎

查看MySQL中现在提供的存储引擎：

```sql
show engines;
```

查看MySQL现在默认使用的存储引擎：

```sql
show variables like '%storage_engine%';
```

**MyISAM引擎和InnoDB引擎简单对比：**

|          | MyISAM引擎        | InnoDB引擎         |
| -------- | ----------------- | ------------------ |
| 外键     | 不支持            | 支持               |
| 事务     | 不支持            | 支持               |
| 行表锁   | 表锁.不适合高并发 | 行锁.适合高并发    |
| 缓存     | 只缓存索引        | 缓存索引和真实数据 |
| 表空间   | 小                | 大                 |
| 关注点   | 性能.偏读         | 事务               |
| 默认安装 | 是                | 是                 |

# MySQL日志

## MySQL的日志分类

- 错误日志
  - -log-err （记录启动，运行，停止mysql时出现的信息）
- 二进制日志
  - -log-bin （记录所有更改数据的语句，还用于复制，恢复数据库用，不建议开启）
- 查询日志
  - -log （记录建立的客户端连接和执行的语句）
- 慢查询日志 
  - -log-slow-queries （记录所有执行超过long_query_time秒的所有查询）
- 更新日志
  - -log-update （二进制日志已经代替了老的更新日志，更新日志在MySQL 5.1中不再使用）

### 查询当前日志记录的状况

```sql
show variables like 'log%';
```

## 错误日志

默认情况下，日志存放在`C:\ProgramData\MySQL\MySQL Server 5.5\data`下，文件名是：当前主机名.err，默认错误日志打开，无法关闭

## 慢查询日志

默认没有开启

### 临时开启：重启后失效

```sql
SET GLOBAL slow_query_log=1; #开启了慢查询日志
SET GLOBAL long_query_time=3;
SHOW VARIABLES LIKE '%slow_query_log%';
```

### 永久开启

修改MySQL安装目录中`my.ini`文件

```ini
# General and Slow logging.
log-output=FILE
general-log=1
general_log_file="general.log"
slow-query-log=1
slow_query_log_file="slow.log"
long_query_time=3
```

### 测试

```sql
SELECT SLEEP(3);
```

执行后，可以看见慢查询日志

![image-20210917113228592](https://gitee.com/yh-gh/img-bed/raw/master/202109181209385.png)

# Explain

可以模拟优化器执行SQL语句，从而知道Mysql是如何处理你的SQL语句的，分析你的SQL语句或者表结构的性能瓶颈

![image-20210917140507497](https://gitee.com/yh-gh/img-bed/raw/master/202109181209681.png)

## id

验证表的读取和加载顺序，select查询的序列号，包含一组数字，表示查询中，执行select子句或操作表的顺序

- 不同id的执行顺序
  - id相同
    - 执行顺序从上向下
  - id不同
    - 如果是子查询，id的序号会递增，id值越大优先级越高，越先被执行
  - id有相同也有不同
    - 序号大的先执行，序号相同的，顺序执行

## select_type

查询的类型，主要是用于区别普通查询，联合查询，子查询等的复杂查询

| select type     | 解释                          | 测试sql                                                      |
| --------------- | ----------------------------- | ------------------------------------------------------------ |
| simple          | 简单的select                  | select * from tbl_student<br />简单的查询，查询中不包含子查询或者UNION。 |
| primary         | 需要union或者子查询           | EXPLAIN #年龄大于平均年龄的同学<br />SELECT * FROM tblstudent WHERE stuage>(<br/>	SELECT AVG(stuage) FROM tblstudent t1<br/>) <br />查询中若包含任何复杂的子部分，最外层则被标记为PRIMARY,一般Primary也是最后被加载的那个 |
| subquery        | 在select或者Where包含的子查询 | 上面的SQL就有subquery                                        |
| derived         | 派生表                        | 在From列表中，包含的子查询被标记为derived,MYSQL会递归执行这些子查询，把结果放在哪临时表（变量内存交换）里面。<br>select * from (select * from tb_student) t<br>#省市区 注意t1是一个虚表<br/>EXPLAIN<br/>	select t2.* from 	<br/>	(SELECT cid FROM zone WHERE zname='未央区') t1,city t2<br/>	where t1.cid=t2.cid |
| union           | union                         | 如第二个select出现在union之后，则被标记为UNION<br>若union包含在From子句的子查询中 ，外层select将被标记为Derived     select * from tb_student union select * from tb_student |
| union result    | union结果集                   | 两种结果的合并，临时表<br>select * from tb_student union select * from tb_student |
| depend subquery | 类似depend union              | select (select name from test.tb_student a where a.id=b.id) from test.tb_student b |
| dependent union | 查询与外部相关                | （mysql优化器会将in优化成exists）  select * from tb_student where id in(select id from tb_student union select id from tb_student) <br>select * from tb_student a where EXISTS (select 1 from tb_student where id = a.id union select id from tb_student where id = a.id) |

## type

- System
  - 表只有一行记录(等于系统表)，这是const类型的特例，平时不会出现，可以忽略不计
- const
  - 表示通过索引一次就找到了，const用于比较primary key或者unique索引，因为只匹配一行数据，所以很快，如将主键置于where列表中，Mysql就能将该查询转换为一个常量
- eq_ref
  - 唯一性索引扫描，对于每个索引键，表中只有一条记录与之匹配。常见于主键或者唯一索引
- ref
  - 非唯一性索引扫描，返回匹配某个单独值的所有行，简单说，用索引查出了多条记录
- range
  - 只检索给定范围的行，使用一个索引来选择行，key列显示是用来那个索引，一般就是在where句中出现了between, < , > , in等的查询
- index
  - Full Index Scan全索引扫描 ,index只遍历索引树，通常比All快，有些情况，索引会被加载到内存中。读索引肯定比权标扫描要快
- All
  - Full Table Scan 全表扫描

查询效率的高低

system>const>eq_ref>ref>range>index>ALL

一般来说，保证查询至少达到range级别，最好达到ref级别

## possible_keys&key

### possible_keys

显示可能应用在这张表中的索引，一个或多个

查询设计到的字段上若存在索引，则该索引将被列出。**但不一定被查询实际使用。**

### key

实际使用到的索引，如果为null，则没有使用索引

查询中若是用了覆盖索引，则该索引仅出现在key列表中

## key_len

表示索引中使用的字节数，可通过该列计算查询中使用的索引的长度。在不损失精确性的情况下，长度越短越好

Key_len显示的值为索引字段的最大可能长度，**并非实际使用长度**，即key_len是根据表定义计算而得，不是通过表内检索出的

## ref

显示索引的那一列被使用了，如果可能的话，是一个常数。那些列或常量被用于查找索引列上的值

## rows

根据表统计信息及索引选用情况，大致估算出找到所需的记录所需要读取的行数。

每张表有多少行被优化器查询

## extra

包含不适合在其他列中显示，但是十分重要的信息

- Using fileSort文件内排序
  - 在使用order by关键字的时候，如果待排序的内容不能由所使用的索引直接完成排序的话，那么mysql有可能就要进行文件排序
- using temporary内部临时表
  - 需要把数据先拷贝到临时表，最后再删除。也非常的慢，最好不要发生。如果要发生，要确保数据量
  - 使用临时表保存中间结果，Mysql在对查询结果排序时使用临时表。常见于排序order by和分组查询group by，往往见于统计分析
- using index
  - select操作中使用了覆盖索引，Covering Index，避免访问了表的数据行，效率高
  - 如果同时出现using where ,表明索引被用来执行索引键值的查找
- using where
  - 使用了条件查询
- using join buffer
  - 使用了链接缓存
- impossible where
  - where子句的值总是false，不能用来获取任何元素
- Using index condition
  - 查询的列不全在索引中，where条件中是一个前导列的范围

# 索引优化

## 单表

例如，有商品表goods

![image-20210919175422609](https://gitee.com/yh-gh/img-bed/raw/master/202109191754701.png)

执行sql语句，查询所有状态为1且价格大于20的商品，并对库存进行排序

```sql
EXPLAIN
SELECT * FROM goods WHERE gstate=1 AND gprice>20 ORDER BY gcount
```

发现结果为，此时不仅类型为全表扫描，而且进行了文件内排序

![image-20210919175558224](https://gitee.com/yh-gh/img-bed/raw/master/202109191755294.png)

所以，建立索引，因为查询使用到的字段为`gprice`，`gcount`，`gstate`，所以添加这三个字段的联合索引

```sql
CREATE INDEX goods_idx_all ON goods(gstate,gprice,gcount)
```

再次执行sql语句

```sql
EXPLAIN
SELECT * FROM goods WHERE gstate=1 AND gprice>20 ORDER BY gcount
```

发现此时，虽然命中索引了，而且type也为range，但是还是进行了文件内排序

![image-20210919180048008](https://gitee.com/yh-gh/img-bed/raw/master/202109191800073.png)

如果将sql语句中的范围查询改为固定常量

```sql
EXPLAIN
SELECT * FROM goods WHERE gstate=1 AND gprice=20 ORDER BY gcount
```

发现结果正常，没有文件内排序了，所以是范围查询引起的文件内排序，原因是：Btree的工作原理，在创建索引的时候，会先对gstate进行排序，如果gstate相同，对gprice进行排序，如果gprice相同，对gcount进行排序，而gprice处于联合索引中间的位置，如果进行范围查询，也就是range，那么范围查询字段后面的索引将失效

![image-20210919180259367](https://gitee.com/yh-gh/img-bed/raw/master/202109191802429.png)

解决方法是

**需要范围查询的字段，不参与联合索引的创建**

## 多表

```sql
EXPLAIN
SELECT * FROM orders LEFT JOIN goods ON orders.git=goods.git
```

执行结果，orders表，进行了全表扫描，而goods表，因为有主键索引，索引命中

![image-20210919195704280](https://gitee.com/yh-gh/img-bed/raw/master/202109191957352.png)

索引的建立规则

如果使用left join，那么关联字段的索引建立在右表上，right join，索引建立在左表上

## 索引失效的解决

1、**最好全值匹配**，索引怎么建立的，就怎么用，使用and连接的查询语句，可以不与索引顺序相同，因为sql优化器会自动进行优化

2、**最佳左前缀法**，查询时，要从索引建立的最左前列（第一列）开始，不可以跳过中间的列，例如

建立索引

```sql
CREATE INDEX goods_idx_all ON goods(gcount,gstate,gprice)
```

只查询前两列，gcount、gstate，结果正常

```sql
EXPLAIN
SELECT * FROM goods WHERE gcount=20 AND gstate=1
```

![image-20210919200827918](https://gitee.com/yh-gh/img-bed/raw/master/202109192008994.png)

只查询第一列，gcount，结果正常

```sql
EXPLAIN
SELECT * FROM goods WHERE gcount=20
```

![image-20210919200916751](https://gitee.com/yh-gh/img-bed/raw/master/202109192009809.png)

只查询第二列和第三列，gstate、gprice，进行了全表扫描，因为中间跳过了索引的第一列

```sql
EXPLAIN
SELECT * FROM goods WHERE gstate=1 AND gprice=35
```

![image-20210919201314148](https://gitee.com/yh-gh/img-bed/raw/master/202109192013217.png)

只查询第一列和第三列，gcount、gprice，虽然使用了索引，但是索引的长度只使用了一个索引，也就是第一列的索引，并没有使用第三列的索引

```sql
EXPLAIN
SELECT * FROM goods WHERE gcount=20 AND gprice=35
```

![image-20210919201546952](https://gitee.com/yh-gh/img-bed/raw/master/202109192015022.png)

3、**不在索引列上做任何的操作**（计算、函数、类型转换），会导致索引失效，全表扫描

4、**不在索引列查询条件前面使用范围查询**（`>`，`<`，`between and`），也就是范围查询后的索引全部失效

5、**查询结果尽量覆盖索引**，也就是，尽量只查询建立索引的字段，少使用`select *`

6、**在MySQL中使用除等于`=`以外的运算符，会导致索引失效**，在MySQL8以后，查询计划的type为all

7、**`is null`和`is not null`会导致索引失效**

8、**`like`中通配符位置除了在右边，其他都会索引失效**，即`like '%M'`、`like '%M%'`

9、**字符串不加单引号，会索引失效**，MySQL引擎会进行类型转换，和第三条意思一样

10、**使用`or`连接，会导致索引失效**

