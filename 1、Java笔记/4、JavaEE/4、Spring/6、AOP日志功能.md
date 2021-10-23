# 记录操作日志

## 1、创建自定义注解类

```java
//用于在service方法上表明操作名称
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LogAnnotation {
    //具体的操作名称
    String operate();
}
```

## 2、service层添加自定义注解

```java
@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;
    @LogAnnotation(operate="查看全部用户")
    public List<User> findAll(){
        return userMapper.selectAll();
    }
    @LogAnnotation(operate="登录")
    public User login(String uaccount,String upsw){
        return userMapper.login(uaccount, upsw);
    }
    @LogAnnotation(operate="添加用户")
    public boolean addUser(User user){
        return userMapper.insert(user)>0? true : false;
    }
    @LogAnnotation(operate="使用uid查询用户")
    public User findByUid(Integer uid){
        return userMapper.findByUid(uid);
    }
    @LogAnnotation(operate="更改用户信息")
    public boolean changeUser(User user){
        return userMapper.updateByPrimaryKeySelective(user)>1? true : false;
    }
    @LogAnnotation(operate="删除用户")
    public boolean delUser(int...uids){
        return userMapper.delUsers(uids)>0? true : false;
    }
}
```

## 3、创建日志实体类，并提供mapper、service

## 4、创建自定义通知类

```java
@Component
@Aspect
public class LogAdvice {
    @Autowired
    private LogService logService;
    //定义切入点
    @Pointcut("execution(* com.woniu.service.UserService.*(..))")
    public void pc(){}

    @AfterReturning(value="pc()",returning="returnVal")
    public void log(JoinPoint jp,Object returnVal){
        //获取代理的方法
        MethodSignature signature= (MethodSignature) jp.getSignature();
        Method me = signature.getMethod();
        //获取session对象
        ServletRequestAttributes attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
        HttpSession session=attr.getRequest().getSession(true);
        //获取当前登录的用户
        User user = (User)session.getAttribute("nowLogin");
        //用户用户登录时，session中无nowLogin
        if(user == null){
            //如果返回值为null,说明登录失败
            if(returnVal == null){
                return;
            }else{
                user = (User)returnVal;
            }
        }
        int uid = user.getUid();
        //获取操作的类型
        String operate = me.getAnnotation(LogAnnotation.class).operate();
        //获取操作的当前时间
        Date date = new Date();
        SimpleDateFormat s = new SimpleDateFormat("yyyy年MM月dd日 HH时mm分ss秒");
        String time = s.format(date);
        Log log = new Log();
        log.setLoperate(operate);
        log.setLtime(time);
        log.setUid(uid);
        logService.addLog(log);
    }
}
```

## 5、xml文件中开启AOP注解

```xml
<aop:aspectj-autoproxy/>
```



 