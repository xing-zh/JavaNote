# 备份和恢复命令

## 备份库

直接在cmd窗口中直接输入，结束不需要输入；

```sql
mysqldump -h端口号 -u用户名 -p密码 数据库名>备份地址
```

## 恢复库

```sql
在cmd窗口中进行
1、连接数据库
mysql -u用户名 -p密码
2、创建数据库
create database 库名
3、切换到可用数据库
use 库名
4、进行恢复
source 备份文件地址
```

# 授权：

## 新用户信息增改

```sql
1.创建用户:
# 指定ip：192.118.1.1的用户登录
create user '用户名'@'192.118.1.1' identified by '密码';
# 指定ip：192.118.1.开头的用户登录
create user '用户名'@'192.118.1.%' identified by '密码';
# 指定任何ip的用户登录
create user '用户名'@'%' identified by '密码';
2.删除用户
drop user '用户名'@'IP地址';
3.修改用户
rename user '用户名'@'IP地址' to '新用户名'@'IP地址';
4.修改密码
set password for '用户名'@'IP地址'=Password('新密码');
```

## 用户权限管理

```sql
#查看用户权限
show grants for '用户名'@'IP地址'
1、授权
#授权用户仅对某文件有查询、插入和更新的操作
grant select,insert,update on 文件名 to '用户名'@'IP地址';
#授权所有的权限，除了grant这个命令，这个命令是root才有的。用户对db1下的t1文件有任意操作
grant all privileges  on db1.t1 to '用户名'@'IP地址';
#授权用户可以对db1数据库中的所有文件执行任何操作
grant all privileges  on db1.* to '用户名'@'IP地址';
#授权用户可以对所有数据库中文件有任何操作
grant all privileges  on *.*  to '用户名'@'IP地址';
 
2、取消权限
# 取消用户对db1的t1文件的任意操作
revoke all on db1.t1 from '用户名'@'IP地址';  
# 取消来自远程服务器的mjj用户对数据库db1的所有表的所有权限
revoke all on db1.* from '用户名'@'IP地址';  
# 取消来自远程服务器的mjj用户所有数据库的所有的表的权限
revoke all privileges on *.* from '用户名'@'IP地址';
```



 