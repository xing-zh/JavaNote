# 1、将Mysql的jar文件集成进项目

# 2、安装插件

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181328335.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181328791.gif)

==将插件中两个文件夹中的文件，复制进eclipse安装目录，并重启==

# 3、编写generatorConfig.xml文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN" "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd" >  
<generatorConfiguration>  

    <!-- 一个数据库一个context -->  
    <context id="context1">  
        <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
        <commentGenerator>
            <property name="suppressDate" value="true" />
            <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
            <property name="suppressAllComments" value="true" />
        </commentGenerator>
        <!-- jdbc连接 -->  
        <jdbcConnection driverClass="com.mysql.jdbc.Driver"  
                        connectionURL="jdbc:mysql://localhost:3306/stu?characterEncoding=utf-8"  
                        userId="root"  
                        password="123456">  
        </jdbcConnection>

        <!-- 生成实体类地址 -->    
        <javaModelGenerator targetPackage="com.woniu.entity"  targetProject="web20210629" > 
        </javaModelGenerator>  

        <!-- 生成mapxml文件 -->  
        <sqlMapGenerator targetPackage="com.woniu.mapper" targetProject="web20210629" >  
        </sqlMapGenerator>  

        <!-- 生成mapxmldao接口 -->      
        <javaClientGenerator targetPackage="com.woniu.mapper"  
                             targetProject="web20210629" type="XMLMAPPER" >
        </javaClientGenerator>  

        <!-- 配置表信息 -->      
        <table schema="" tableName="student" ></table>  

    </context>  
</generatorConfiguration>  
```

# 4、右键生成即可