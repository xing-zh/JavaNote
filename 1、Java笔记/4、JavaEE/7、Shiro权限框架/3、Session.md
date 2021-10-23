# 生命周期

1、在首次调用subject.login()方法时，创建Session对象

2、默认30分钟过期

3、在调用subject.logout()方法时，销毁Session对象

# 相关方法

**subject.login()**：主体登录（认证）方法，同时创建Session对象

**subject.getSession()**：获取Shiro封装的Session对象

**subject.logout()**：主体登出方法，同时会销毁Session对象

# Session监听

## 1、创建自定义监听器，实现SessionListener接口

```java
public class ShiroSessionListener implements SessionListener{
    //使用AtomicInteger，线程安全，统计在线人数
    private final AtomicInteger sessionCount = new AtomicInteger(0);
    public AtomicInteger getOnLineSessionCount(){
        return this.sessionCount;
    }
    //session过期，执行该方法
    @Override
    public void onExpiration(Session arg0) {
        System.out.println("会话过期,在线人数减一");
        sessionCount.decrementAndGet();
    }
    //客户端首次访问服务器，创建session对象，执行该方法
    @Override
    public void onStart(Session arg0) {
        System.out.println("首次访问服务器时,会话人数加一");
        sessionCount.incrementAndGet();
    }
    //session调用stop方法时，执行该方法
    @Override
    public void onStop(Session arg0) {
        System.out.println("退出时，会话人数减一");
        sessionCount.decrementAndGet();
    }
}
```

## 2、在ShiroConfig中，对SessionListener、SessionManager进行注入

```java
//自定义的SessionListener组件
@Bean
public ShiroSessionListener getShiroSessionListener(){
    return new ShiroSessionListener();
}
//SessionManager组件
@Bean
public SessionManager getSessionManager(){
    //获取一个SessionManager实现类
    DefaultWebSessionManager sessionManager = new DefaultWebSessionManager();
    //创建集合，将自定义的SessionListener存入集合
    List<SessionListener> list = new ArrayList<>();
    list.add(getShiroSessionListener());
    //设置自定义SessionListener到SessionManager中
    sessionManager.setSessionListeners(list);
    //默认session存活时间30分钟
    sessionManager.setGlobalSessionTimeout(1000*60*30);
    return sessionManager;
}
//配置安全管理器
@Bean
public DefaultWebSecurityManager getDefaultWebSecurityManager(){
    DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
    //安全管理器管理创建的Realm域对象
    securityManager.setRealm(getLoginAndAuthRealm());
    //安全管理器管理创建的SessionManager对象
    securityManager.setSessionManager(getSessionManager());
    return securityManager;
}
```



 