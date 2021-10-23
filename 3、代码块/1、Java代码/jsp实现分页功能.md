# JSP:

```jsp
<tr>
    <td colspan="9">共${pageInfo.pages}页，当前第${pageInfo.pageNum}页
        <div style="float: right">
            <button 
                    ${pageInfo.pageNum == 1 ? "disabled = 'disabled'":""}
                    onclick="pageGo(${pageInfo.pageNum - 1})">
                上一页
            </button>
            <c:forEach
                       begin="${pageInfo.pageNum < 3? 1 : pageInfo.pageNum - 2}"
                       end="${pageInfo.pageNum < 3? 1 + 4 : pageInfo.pageNum - 2 + 4}"
                       var="num">
                <c:choose>
                    <%--   当按钮超过总页数，不可点击  --%>
                    <c:when test="${num > pageInfo.pages}">
                        <button disabled="disabled">${num}</button>
                    </c:when>
                    <%--   当按钮等于当前页数，不可点击，更改样式  --%>
                    <c:when test="${num == pageInfo.pageNum}">
                        <button onclick="pageGo(${num})" disabled="disabled">${num}</button>
                    </c:when>
                    <%--   其他情况正常点击  --%>
                    <c:otherwise>
                        <button onclick="pageGo(${num})">${num}</button>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <button 
                    ${pageInfo.pageNum == pageInfo.pages ? "disabled = 'disabled'":""}
                    onclick="pageGo(${pageInfo.pageNum + 1})">
                下一页
            </button>
        </div>
    </td>
</tr>
```

# js:

```js
function pageGo(pageGo){
    location.href="findAll.do?pageGo="+pageGo;
}
```

# java：

如果是SpringMVC，需要在spring配置文件中添加插件

```xml
<!-- 配置SessionFactory -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <!-- 数据库连接池 -->
    <property name="dataSource" ref="dataSource" />
    <!-- 加载mybatis的全局配置文件 -->
    <property name="configLocation" value="classpath:mybatisConfig.xml" />
    <property name="plugins">
        <array>
            <bean class="com.github.pagehelper.PageInterceptor">
                <property name="properties">
                    <props>
                        <prop key="helperDialect">mysql</prop>
                        <prop key="reasonable">true</prop>
                    </props>
                </property>
            </bean>
        </array>
    </property>
</bean>
```

```java
@RequestMapping("/findAll.do")
public String findAll(ModelMap modelMap,Integer pageGo){
    PageInfo<User> pageInfo = null;
    System.out.println(pageGo);
    if(pageGo == null){
        pageInfo = userService.findAllByPage(1, 5);
    }else{
        pageInfo = userService.findAllByPage(pageGo, 5);
    }
    modelMap.put("pageInfo", pageInfo);
    System.out.println(pageInfo);
    return "jsp/main.jsp";
}
```

