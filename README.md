# session_server

微信小程序会话管理为微信小程序提供会话管理服务，可以将它理解为session.它会为您的微信小程序提供简单的用户管理服务。

## 会话管理服务功能

1）用户登录鉴权功能

   用户登录功能指的是：用户在微信小程序客户端发起登录请求时，首先经过微信客户端获取code以及用户加密数据的信息。此时只需将获取的这两个信息以参数的形式传递给会话管理服务器。会话管理服务器会根据code和用户加密数据，与微信服务端进行交互，如果鉴权通过会返回分配给该用户的id和skey，以及解密后的用户明文信息。如图所示
   
   ![image](https://cloud.githubusercontent.com/assets/12195370/19835570/0170947a-9ec6-11e6-8e6a-6163afae4288.png)
     
2 登录态校验功能
     
   用户登录态校验功能指的是：微信小程序用户处于登录态时，如果下一步的操作需要用户态校验的时候，只要将在登录鉴权功能时分配的id和skey以参数的形式传递给会话管理服务器，会话管理便会提供鉴权功能，并返回鉴权结果。如图所示
   
   ![image](https://cloud.githubusercontent.com/assets/12195370/19835618/580cf7c8-9ec7-11e6-9add-8e7f3497095a.png)
     
     
3）解密数据功能
   
   解密数据功能指的是：微信客户端返回给微信小程序的用户信息是通过加密的，所以需要解密后使用。
    
## 会话管理数据库设计

全局信息表 cAppInfo

<table>
  <tbody>
  <tr>
    <th>Field</th>
    <th>Type</th>
    <th>Null</th>
    <th>key</th>
    <th>Extra</th>
  </tr>
  <tr>
    <td>  appid </td>
    <td> varchar(200) </td>
    <td> NO </td>
    <td> PRI </td>
    <td> 申请微信小程序开发者时，微信分配的appid值 </td>
  </tr>
  <tr>
    <td>  secret  </td>
    <td> varchar(300) </td>
    <td> NO </td>
    <td>  </td>
    <td> 申请微信小程序开发者时，微信分配的secret值 </td>
  </tr>
  <tr>
    <td>  login_duration  </td>
    <td>  int(11) </td>
    <td> NO </td>
    <td>  </td>
    <td> 登录过期时间，单位为天，默认30天</td>
  </tr>
  <tr>
    <td>  session_duration  </td>
    <td>  int(11) </td>
    <td> NO </td>
    <td>  </td>
    <td> session过期时间，单位为秒，默认3600妙 </td>
  </tr>
  
  </tbody>
</table>
    

session表 cSessionInfo

<table>
  <tbody>
  <tr>
    <th>Field</th>
    <th>Type</th>
    <th>Null</th>
    <th>key</th>
    <th>Extra</th>
  </tr>
  <tr>
    <td> id </td>
    <td>  bigint(20) </td>
    <td> NO </td>
    <td> MUL </td>
    <td> 登录成功时返回给小程序服务端的id（鉴权使用），自增长 </td>
  </tr>
  <tr>
    <td>  skey  </td>
    <td> varchar(200) </td>
    <td> NO </td>
    <td>  </td>
    <td> 登录成功时返回给小程序服务端的skey（鉴权使用） </td>
  </tr>
  <tr>
    <td>  create_time  </td>
    <td>  int(11) </td>
    <td> NO </td>
    <td>  </td>
    <td> session创建时间，用于判断登录的open_id和session_key 是否过期(是否超过cAppInfo表中字段login_duration的天数)</td>
  </tr>
  <tr>
    <td>  last_visit_time  </td>
    <td>  int(11) </td>
    <td> NO </td>
    <td>  </td>
    <td> session最近访问时间，用于判断session是否过期(是否超过cAppInfo表中字段session_duration的秒数) </td>
  </tr>
  <tr>
    <td>  open_id  </td>
    <td>   varchar(200) </td>
    <td> NO </td>
    <td> MUL </td>
    <td> 微信服务端返回的open_id值 </td>
  </tr>
  <tr>
    <td> session_key  </td>
    <td>   varchar(200) </td>
    <td> NO </td>
    <td>  </td>
    <td> 微信服务端返回的session_key值 </td>
  </tr>
  <tr>
    <td>  user_info  </td>
    <td> text </td>
    <td> YES </td>
    <td>  </td>
    <td> 用户数据 </td>
  </tr>
  
  </tbody>
</table>

建数据库的详细sql脚本位于./system/db/目录下的db.sql。

db.sql内容如下

    create database cAuth;
    
    use cAuth;

    DROP TABLE IF EXISTS `cAppinfo`;

    CREATE TABLE `cAppinfo` (

      `appid` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  
      `secret` varchar(300) COLLATE utf8_unicode_ci NOT NULL,
  
      `login_duration` int(11) DEFAULT '30',
  
      `session_duration` int(11) DEFAULT '3600'
  
    PRIMARY KEY (`appid`)
  
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

    DROP TABLE IF EXISTS `cSessioninfo`;

    CREATE TABLE `cSessioninfo` (

      `id` bigint(20) NOT NULL AUTO_INCREMENT,
  
      `skey` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  
      `create_time` int(11) NOT NULL,
  
      `last_visit_time` int(11) NOT NULL,
  
      `open_id` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  
      `session_key` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  
      `user_info` text COLLATE utf8_unicode_ci,
  
      KEY `auth` (`id`,`skey`),
  
      KEY `wexin` (`open_id`,`session_key`)
  
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


## 会话管理接口协议

编码类型：utf8

编码格式：json

传输方式：post

请求协议：http

使用示例：

{"version":1,"componentName":"MA","interface":{"interfaceName":"接口名""para":{接口对应参数}}}

返回值:

返回结果。returnCode为返回码，如果成功则取值为0，如果失败则取值为具体错误码；returnMessage 内容为出错信息；returnData为具体内容。

## 会话管理接口说明

对外提供两个接口分别是：

1）用户登录

接口名：qcloud.cam.id_skey

返回值：id,ske以及用户信息

使用示例：

    curl -i -d'{"version":1,"componentName":"MA","interface":{"interfaceName":"qcloud.cam.id_skey","para":{"code":"001EWYiD1CVtKg0jXGjD1e6WiD1EWYiC","encrypt_data":"DNlJKYA0mJ3+RDXD/syznaLVLlaF4drGzeZvJFmjnEKtOAi37kAzC/1tCBr7KqGX8EpiLuWl8qt/kcH9a4LxDC5LQvlRLJlDogTEIwtlT/2jBWBuWwBC3vWFhm7Uuq5AOLZV+xG9UmWPKECDZX9UZpWcPRGQpiY8OOUNBAywVniJv6rC2eADFimdRR2qPiebdC3cry7QAvgvttt1Wk56Nb/1TmIbtJRTay5wb+6AY1H7AT1xPoB6XAXW3RqODXtRR0hZT1s/o5y209Vcc6EBal5QdsbJroXa020ZSD62EnlrOwgYnXy5c8SO+bzNAfRw59SVbI4wUNYz6kJb4NDn+y9dlASRjlt8Rau4xTQS+fZSi8HHUwkwE6RRak3qo8YZ7FWWbN2uwUKgQNlc/MfAfLRcfQw4XUqIdn9lxtRblaY="}}}' http://127.0.0.1/mina_auth/

2）登录态校验

接口名：qcloud.cam.auth

返回值：是否校验通过

使用示例：

    curl -i -d'{"version":1,"componentName":"MA","interface":{"interfaceName":"qcloud.cam.auth","para":{"id":"4","skey":"f27b6d7724479266761075243bc223c5"}}}' http://127.0.0.1/mina_auth/

## 会话管理错误码解释

0;      //成功返回码

1001;    // Mysql错误等

1002;    // 接口参数不存在

1003;    //参数错误

60021;   //解密失败

1005;    //连接微信服务器失败

40029;   //CODE无效

1006;    //新增修改SESSION失败

1007;    //微信返回值错误

60012;   //鉴权失败

1008;    //更新最近访问时间失败

1009;    //请求包不是json

1010;    //接口名称错误

1011;    //不存在参数

1012;    //不能获取AppID

1013;    //初始化AppID失败

## 会话管理服务器快速搭建

1)[进入腾讯云官网购买云服务器CVM](https://www.qcloud.com/product/cvm.html)

![image](https://cloud.githubusercontent.com/assets/12195370/19964833/f6b57b22-a1fe-11e6-9cdf-512c318eabfb.png)

                                              图1 选购云服务器CVM
                                              
![image](https://cloud.githubusercontent.com/assets/12195370/19965033/074bb400-a200-11e6-8f00-9909635fb616.png) 

                                              图2 选择机型
                                              
![image](https://cloud.githubusercontent.com/assets/12195370/19965102/529823d0-a200-11e6-891f-ee0e8552af95.png)
                                              
                                              图3 在服务市场中选择镜像
                                              
![image](https://cloud.githubusercontent.com/assets/12195370/19965255/20c224b8-a201-11e6-9092-5cbb15becb00.png)
                        
                                              图4 选择会话服务器镜像
                            
2)登录购买的服务器手动配置mysql 

2.1)编辑sql脚本

    vi /opt/lampp/htdocs/mina_auth/system/db/db.sql
    
在脚本的最前端加入 use cAuth;

2.2)自动建表

    /opt/lampp/bin/mysql -u root -p </opt/lampp/htdocs/mina_auth/system/db/db.sql
   
2.3）初始化appid和scretkey

    /opt/lampp/bin/mysql -u root -p #登录本地mysql
    
    use cAuth;#选中数据库
    
    insert into cAppinfo set appid='Your appid',secret='Your secret';
    
2.3)测试服务可用性
   
    curl -i -d'{"version":1,"componentName":"MA","interface":{"interfaceName":"qcloud.cam.id_skey","para":{"code":"001EWYiD1CVtKg0jXGjD1e6WiD1EWYiC","encrypt_data":"DNlJKYA0mJ3+RDXD/syznaLVLlaF4drGzeZvJFmjnEKtOAi37kAzC/1tCBr7KqGX8EpiLuWl8qt/kcH9a4LxDC5LQvlRLJlDogTEIwtlT/2jBWBuWwBC3vWFhm7Uuq5AOLZV+xG9UmWPKECDZX9UZpWcPRGQpiY8OOUNBAywVniJv6rC2eADFimdRR2qPiebdC3cry7QAvgvttt1Wk56Nb/1TmIbtJRTay5wb+6AY1H7AT1xPoB6XAXW3RqODXtRR0hZT1s/o5y209Vcc6EBal5QdsbJroXa020ZSD62EnlrOwgYnXy5c8SO+bzNAfRw59SVbI4wUNYz6kJb4NDn+y9dlASRjlt8Rau4xTQS+fZSi8HHUwkwE6RRak3qo8YZ7FWWbN2uwUKgQNlc/MfAfLRcfQw4XUqIdn9lxtRblaY="}}}' http://127.0.0.1/mina_auth/
    
    
