![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181328981.gif)

# generatorConfig.xml文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
<generatorConfiguration>
  <!-- 数据库驱动:选择你的本地硬盘上面的数据库驱动包-->
  <classPathEntry  location="F:\Maven\Maven-jar\mysql\mysql-connector-java\5.1.38\mysql-connector-java-5.1.38.jar"/>
  <context id="DB2Tables"  targetRuntime="MyBatis3">
    <commentGenerator>
      <property name="suppressDate" value="true"/>
      <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
      <property name="suppressAllComments" value="true"/>
    </commentGenerator>
    <!--数据库链接URL，用户名、密码 -->
    <jdbcConnection driverClass="com.mysql.jdbc.Driver" connectionURL="jdbc:mysql://localhost:3306/stu" userId="root" password="123456">
    </jdbcConnection>
    <javaTypeResolver>
      <property name="forceBigDecimals" value="false"/>
    </javaTypeResolver>
    <!-- 生成实体类的包名和位置-->
    <javaModelGenerator targetPackage="com.example.ssmtest.entity" targetProject="F:\javastudy\school_study202106\ssmtest\src\main\java">
    </javaModelGenerator>
    <!-- 生成映射文件的包名和位置-->
    <sqlMapGenerator targetPackage="com.example.ssmtest.mapper" targetProject="F:\javastudy\school_study202106\ssmtest\src\main\java">
    </sqlMapGenerator>
    <!-- 生成mapper位置-->
    <javaClientGenerator type="XMLMAPPER" targetPackage="com.example.ssmtest.mapper" targetProject="F:\javastudy\school_study202106\ssmtest\src\main\java">
    </javaClientGenerator>

    <!-- 要生成的表-->
    <table schema="" tableName="student" ></table>

  </context>
</generatorConfiguration>
```

# 或者使用

better-mybatis-generator

 