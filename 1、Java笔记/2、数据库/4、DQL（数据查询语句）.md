# 基础查询

## 语法：

```sql
select 列名1, ... ,列名n from 表名
where 条件        -- 1、条件
group by 列名     -- 2、分组
having 条件       -- 3、条件
order by 列名     -- 4、排序
limit 开始，条数   -- 5、分页
```

## 关于列的操作

### 1、查询所有列所有行

```sql
select * from 表名
```

### 2、查询指定列

```sql
#多列列名使用，隔开 
select 列名 from 表名
```

### 3、给列起别名

```sql
select 列名 [as] 别名,列名n [as] 别名n
```

### 4、列查询并进行算术运算

```sql
#列和固定数值
select 列名+\-\*\/\%数值 from 表名
#列和列
select 列名+\-\*\/\%列名 from 表名
```

### 5、多列进行合并为一列查询

```sql
select concat(列名1,列名2,...)合并后列名 from 表名
```

### 6、查询过程增加常量列

```sql
select * ,'常量' 列名 from 表名
```

# 条件查询（where）

## 1、比较运算符作为处理条件

==（=,>,<,>=,<=,!=\<>,如果是null，需要写为is\is not )==

```sql
select * from 表名 where 列名=值
```

## 2、多条件

### 1）同时满足（and）

```sql
select * from 表名 where 列名1=值 and 列名2=值
```

### 2）或者（or）

```sql
#不同列
select * from 表名 where 列名1=值 or 列名2=值
#同一列的不同值
select * from 表名 where 列名 in (值1,值2,...)
select * from 表名 where 列名 not in (值1,值2,...)
```

### 3）模糊查询（like）

```sql
#查询l开头的名字，任意长度
select * from 表名 where 列名 like 'l%'
#查询l开头的名字，固定长度
select * from 表名 where 列名 like 'l__'
#查询包含o的名字
select * from 表名 where 列名 like '%o%'
```

### 4）上下界（between）

```sql
select * from 表名 where 列名 between 下界值 and 上界值
```

# 排序查询（order by）

## 升序

```sql
select * from 表名 order by 列名
select * from 表名 order by 列名 asc
```

## 降序

```sql
select * from 表名 order by 列名 desc
```

## 排序相等行，在进行排序

```sql
select * from 表名 order by 列名1 desc,列名2 desc
```

# 分页查询（limit）

```sql
#起始位置默认为0，查询不包括起始位置
select * from 表名 limit 起始位置,每页条目数
```

## 公式

```sql
#假如要显示的页数为page，每一页条目数为size
select 查询列表
from 表
limit (page-1)*size,size;
```

# 聚合函数

关于某一列进行操作，**和行没有关系**

| **count()** | **返回结果集中行的数目**       |
| ----------- | ------------------------------ |
| **max()**   | **返回结果集中所有值的最大值** |
| **min()**   | **返回结果集中所有值的最小值** |
| **sum()**   | **返回结果集中所有值的总和**   |
| **avg()**   | **返回结果集中所有值的平均值** |

## 用法

**聚合函数null值不参与运算**，如果希望null值也参与那么需要**ifnull()**函数处理

```sql
select 函数名(列名) from 表名
```

# 分组查询（group by）

```sql
select 分组列名,聚合函数 from 表名 group by 分组列名
#一般和聚合函数一起使用
#如，查询student表中的男女两个分组中的最大年龄和最小年龄
select ssex,max(sage),min(sage) from student group by ssex
```

## 条件筛选（having）

**group by后不可以使用where进行筛选**，需要使用**having**关键字

**如果能用where筛选数据的话，绝不使用having**

### where和having的区别？

* 都是进行条件判断的关键字
* where条件判断是在分组前判断，having条件判断是在分组后判断
* where关键字要写在group by前面，having关键字要写在group by后面
* where条件里不能写聚合函数，having条件里可以写聚合函数

```sql
#如，查询年龄大于11的各个年龄段的人数
select sage,count(sage) from student group by sage having sage > 11
#可以使用where就不要用having
select sage,count(sage) from student where sage > 11 group by sage
```

# 联合查询（union）

1. 要求多条查询语句的查询**列数必须一致**
2. 要求多条查询语句的查询的各列类型、顺序最好一致
3. union 去重，union all包含重复项

```sql
1. 将2个表的数据进行拼接，针对拼接后的重复数据 去重显示
select 列名 from 表名1 where 条件
union 
select 列名 from 表名2 where 条件
2. 将2个表的数据进行拼接，针对拼接后的重复数据 不去重显示
select 列名 from 表名1 where 条件
union all
select 列名 from 表名2 where 条件
```

# 多表联合查询

```sql
#sql92
select * from 表1,表2;
#sql99
select * from 表1 cross join 表2;
```

笛卡尔积组合，形成数据没有价值

## 内连接（inner join）

```sql
select 列名 from A表 
inner join B表 on 关联条件;
```

## 外连接

### 左外连接（left）

```sql
select 列名 from A表 
left join B表 on 关联条件;
```

### 右外连接（right）

```sql
select 列名 from A表 
right join B表 on 关联条件;
```

## 自连接

```sql
#查询1号课程成大于2号课程的学生id
select * from sc s1  
inner join sc s2 
on s1.sno=s2.sno
where s1.cno=1 and s2.cno=2 and s1.score>s2.score
```

## 去重（distinct）

```sql
select distinct 列名 from 表名;
```

# 子查询

嵌套查询，就是指一个sql语句里面还有一条sql语句

将查询的结果（可以作为值，也可以作为表），再次被sql语句使用

## 结果为一个值

```sql
#查询李华老师所带课程
select * from course where tno = 
(
    	select tno from teacher where tname = '李华'
)
```

## 结果为一个表（多个值）

```sql
#查询李华老师所带学生的信息
-- 1 获取李华老师的编号
select tno from teacher where tname = '李华'
-- 2 根据老师的编号获取所带学科的编号
select cno from course where cno in 
(
    	select tno from teacher where tname = '李华'
)
-- 3 根据学科编号获取学生的编号
select sno from sc where cno in 
(
	select cno from course where cno in 
	(
			select tno from teacher where tname = '李华'
	)
)
-- 4 根据学生编号，获取学生的信息
select * from student where sno in 
(
	select sno from sc where cno in 
	(
		select cno from course where cno in 
		(
				select tno from teacher where tname = '李华'
		)
	)
)
```

## any（满足该字段任何一个值，‘或’）

```sql
#查询学生表中，年龄大于张三或tony的学生信息
select * from student where sage > any(
    select sage from student where sname = '张三' or sname = 'tony'
)
```

## all（满足该字段所有的值，‘且’）

```sql
#查询学生表中，年龄大于张三并且大于tony的学生信息
select * from student where sage > all(
    select sage from student where sname = '张三' or sname = 'tony'
)
```

## exists和in的区别

 

# 扩展

## 按照条件显示不同信息（case、when、then、else、end）

```sql
#查询student表中，按照年龄显示是否成年
select *,
case 
	when sage >= 18 then '成年'
    else '未成年'
    end
from student
```



 