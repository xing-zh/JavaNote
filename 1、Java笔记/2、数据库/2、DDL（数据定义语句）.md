# 库管理

## 建库操作

```sql
#创建数据库（默认字符集编码） 
create database test20210420 
#创建数据库的时候指定字符集编码以及字符校验规则 
create database test20210420 CHARACTER set = utf8 COLLATE utf8_general_ci 
#切换可用数据库(建表之前一定要切换) 
use test20210420 
#查看服务器的所有数据库 
show databases 
#删除数据库
drop database test20210420
#修改数据库字符集编码以及字符校验规则 
alter database test20210420 CHARACTER set = utf8 COLLATE utf8_general_ci 
#查看数据库信息 
show create database test20210420
```

# 表管理

## 建表操作

```sql
#创建表：创建表的格式 
create table student( student_id int, student_name varchar(20), student_birth int ) 
#插入数据的命令 
insert into student values(1,'姚明',20) 
#查询 
select * from student 
#删除表 
drop table student
```

## 复制表操作

```sql
#结构和数据一起复制(有创建表) 
create table testchar1 as select * from testchar 
#结构复制(有创建表) 
create table testchar2 like testchar
```

## 修改表操作

```sql
#1.给表中增加列 
alter table testchar add t_age int 
#2.给修改列名及列定义 
alter table testchar change t_name1 t_name2 varchar(50) 
#3.修改列定义
alter table testchar modify t_name2 varchar(100)
#4.删除列 
alter table testchar drop t_age
```

## 辅助命令

```sql
#查看当前数据库中所有的表 
SHOW TABLES; 
#查看表的定义信息 
SHOW CREATE TABLE testchar 
#删除表 
drop table testchar 
#表重新命名 
Rename table testchar to testchar3
```

# 约束：

**NOT NULL**：**非空**，该字段的值必填

**UNIQUE**：**唯一**，该字段的值不可重复

**DEFAULT**：**默认**，该字段的值不用手动插入有默认值

**CHECK**：**检查**，mysql不支持

**PRIMARY KEY**：**主键**，该字段的值不可重复并且非空 unique+not null

**FOREIGN KEY**：**外键**，该字段的值引用了另外的表的字段

## 主键和唯一的异同：

区别：

①一个表至多有一个主键，但可以有多个唯一

②主键不允许为空，唯一可以为空

相同点

①都具有唯一性

②都支持组合键，但不推荐

## 主表和从表：

主表（父表）被引用字段所在的表

在数据库中建立的表格即Table，其中存在主键(primary key)用于与其它表相关联，并且作为在主表中的唯一性标识。

从表（子表）

以主表的主键（primary key）值为外键(Foreign Key)的表，可以通过外键与主表进行关联查询。从表与主表通过外键进行关联查询。

## 修改表时添加或删除约束

```sql
#1、非空     
    #添加非空     
    alter table 表名 modify column 字段名 字段类型 not null;     
    #删除非空     
    alter table 表名 modify column 字段名 字段类型 ; 
#2、默认     
    #添加默认   
    alter table 表名 modify column 字段名 字段类型 default 值;     
    #删除默认     
    alter table 表名 modify column 字段名 字段类型 ; 
#3、主键     
    #添加主键     
    alter table 表名 add【constraint 约束名】 primary key(字段名);   
    #删除主键     
    alter table 表名 drop primary key; 
#4、唯一   
    #添加唯一   
    alter table 表名 add【 constraint 约束名】 unique(字段名);     
    #删除唯一     
    alter table 表名 drop index 索引名; 
#5、外键   
    #添加外键   
    alter table 表名 add【 constraint 约束名】 foreign key(字段名) references 主表（被引用列）;   
    #删除外键   
    alter table 表名 drop foreign key 约束名;
#自增长列
    #添加自增长列
    alter table 表 modify column 字段名 字段类型 约束 auto_increment
    #删除自增长列
    alter table 表 modify column 字段名 字段类型 约束 
```



#  