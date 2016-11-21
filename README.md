Wafer 会话服务器
===============

本项目是 [Wafer](https://github.com/tencentyun/wafer) 组成部分，提供会话服务供 SDK 或独立使用。

会话服务的实现细请参考 [Wiki](https://github.com/tencentyun/wafer/wiki/%E4%BC%9A%E8%AF%9D%E6%9C%8D%E5%8A%A1)。


## 接口协议

### 请求

会话服务器提供 HTTP 接口来实现会话管理，下面是协议说明。

* 协议类型：`HTTP`
* 传输方式：`POST`
* 编码类型：`UTF-8`
* 编码格式：`JSON`

请求示例：

```http
POST /mina_auth/ HTTP/1.1
Content-Type: application/json;charset=utf-8

{
    "version": 1,
    "componentName": "MA",
    "interface": {
        "interfaceName": "qcloud.cam.id_skey",
        "para": { "code": "...", "encrypt_data": "..." }
    }
}
```

### 响应

HTTP 输出为响应内容，下面是响应内容说明：

* 内容编码：`UTF-8`
* 内容格式：`JSON`

响应示例：

```json
{
    "returnCode": 0,
    "returnMessage": "OK",
    "returnData": {
        "id": "...",
        "skey": "..."
    }
}
```

* `returnCode` - 返回码，如果成功则取值为 `0`，如果失败则取值为具体错误码；
* `returnMessage` - 如果返回码非零，内容为出错信息；
* `returnData` - 返回的数据

### qcloud.cam.id_skey

`qcloud.cam.id_skey` 处理用户登录请求。

使用示例：

```sh
curl -i -d'{"version":1,"componentName":"MA","interface":{"interfaceName":"qcloud.cam.id_skey","para":{"code":"001EWYiD1CVtKg0jXGjD1e6WiD1EWYiC","encrypt_data":"DNlJKYA0mJ3+RDXD/syznaLVLlaF4drGzeZvJFmjnEKtOAi37kAzC/1tCBr7KqGX8EpiLuWl8qt/kcH9a4LxDC5LQvlRLJlDogTEIwtlT/2jBWBuWwBC3vWFhm7Uuq5AOLZV+xG9UmWPKECDZX9UZpWcPRGQpiY8OOUNBAywVniJv6rC2eADFimdRR2qPiebdC3cry7QAvgvttt1Wk56Nb/1TmIbtJRTay5wb+6AY1H7AT1xPoB6XAXW3RqODXtRR0hZT1s/o5y209Vcc6EBal5QdsbJroXa020ZSD62EnlrOwgYnXy5c8SO+bzNAfRw59SVbI4wUNYz6kJb4NDn+y9dlASRjlt8Rau4xTQS+fZSi8HHUwkwE6RRak3qo8YZ7FWWbN2uwUKgQNlc/MfAfLRcfQw4XUqIdn9lxtRblaY="}}}' http://127.0.0.1/mina_auth/
```

响应数据：

* `id` - 会话 id
* `skey` - 会话 skey
* `userInfo` - 用户信息

### qcloud.cam.auth

使用 `qcloud.cam.auth` 接口检查用户登录态。

响应数据：

* `true` - 登录态有效
* `false` - 登录态无效

### 错误码
<table>
  <tbody>
  <tr>
    <th>错误码</th>
    <th>解释</th>
  </tr>
  <tr>
    <td>0</td>
    <td>成功</td>
  </tr>
  <tr>
    <td>1001</td>
    <td>数据库错误</td>
  </tr>
   <tr>
    <td>1002</td>
    <td>接口不存在</td>
  </tr>
  <tr>
    <td>1003</td>
    <td>参数错误</td>
  </tr>
  <tr>
    <td>1005</td>
    <td>连接微信服务器失败</td>
  </tr>
   <tr>
    <td>1006</td>
    <td>新增或修改 SESSION 失败</td>
  </tr>
  <tr>
    <td>1007</td>
    <td>微信返回值错误</td>
  </tr>
  <tr>
    <td>1008</td>
    <td>更新最近访问时间失败</td>
  </tr>
  <tr>
    <td>1009</td>
    <td>请求包不是json</td>
  </tr>
  <tr>
    <td>1010</td>
    <td>接口名称错误</td>
  </tr>
  <tr>
    <td>1011</td>
    <td>参数不存在</td>
  </tr>
   <tr>
    <td>1012</td>
    <td>不能获取 AppID</td>
  </tr>
   <tr>
    <td>1013</td>
    <td>初始化 AppID 失败</td>
  </tr>
  <tr>
    <td>40029</td>
    <td>CODE 无效</td>
  </tr>
  <tr>
    <td>60021</td>
    <td>解密失败</td>
  </tr>
  <tr>
    <td>60012</td>
    <td>鉴权失败</td>
  </tr>
  </tbody>
</table>

    
## 数据库设计

全局信息表 `cAppInfo` 保存会话服务所需要的配置项。

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
    <td>appid</td>
    <td>varchar(200)</td>
    <td>NO</td>
    <td>PRI</td>
    <td>申请微信小程序开发者时，微信分配的 appId</td>
  </tr>
  <tr>
    <td>secret</td>
    <td>varchar(300)</td>
    <td>NO</td>
    <td></td>
    <td>申请微信小程序开发者时，微信分配的 appSecret</td>
  </tr>
  <tr>
    <td>login_duration</td>
    <td>int(11)</td>
    <td>NO</td>
    <td></td>
    <td>登录过期时间，单位为天，默认 30 天</td>
  </tr>
  <tr>
    <td>session_duration</td>
    <td>int(11)</td>
    <td>NO</td>
    <td></td>
    <td>会话过期时间，单位为秒，默认为 2592000 秒(即30天)</td>
  </tr>
  
  </tbody>
</table>
    

会话记录 `cSessionInfo` 保存每个会话的数据。

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
    <td>id</td>
    <td>int(11)</td>
    <td>NO</td>
    <td>MUL</td>
    <td>会话 ID（自增长）</td>
  </tr>
   <tr>
    <td>uuid</td>
    <td>varchar(100)</td>
    <td>NO</td>
    <td></td>
    <td>会话 uuid</td>
  </tr>
  <tr>
    <td>skey</td>
    <td>varchar(100)</td>
    <td>NO</td>
    <td></td>
    <td>会话 Skey</td>
  </tr>
  <tr>
    <td>create_time</td>
    <td>datetime</td>
    <td>NO</td>
    <td></td>
    <td>会话创建时间，用于判断会话对应的 open_id 和 session_key 是否过期（是否超过 `cAppInfo` 表中字段 `login_duration` 配置的天数）</td>
  </tr>
  <tr>
    <td>last_visit_time</td>
    <td>datetime</td>
    <td>NO</td>
    <td></td>
    <td>最近访问时间，用于判断会话是否过期（是否超过 `cAppInfo` 表中字段 `session_duration` 的配置的秒数）</td>
  </tr>
  <tr>
    <td>open_id</td>
    <td>varchar(100)</td>
    <td>NO</td>
    <td>MUL</td>
    <td>微信服务端返回的 `open_id` 值 </td>
  </tr>
  <tr>
    <td>session_key</td>
    <td>varchar(100)</td>
    <td>NO</td>
    <td></td>
    <td>微信服务端返回的 `session_key` 值 </td>
  </tr>
  <tr>
    <td>user_info</td>
    <td>varchar(2048)</td>
    <td>YES</td>
    <td></td>
    <td>已解密的用户数据</td>
  </tr>
  </tbody>
</table>

建数据库的详细 SQL 脚本请参考 [db.sql](https://github.com/tencentyun/wafer-session-server/blob/master/db.sql)


## 搭建会话管理服务器

选择合适的方式[部署](https://github.com/tencentyun/wafer/wiki#%E9%83%A8%E7%BD%B2%E6%96%B9%E5%BC%8F) Wafer 服务后，按照部署类型：

* 自动部署 - 无需进行任何操作，会话服务器已经可以使用
* 镜像部署 - 按照下面步骤进行初始化工作
* 自行部署 - 按照下面步骤进行初始化工作


### 环境准备

确保机器中已安装 LAMP 环境。

### 代码部署

把本项目代码部署到 `/opt/lampp/htdocs/mina_auth` 目录中。

### 自动建表

执行下面命令创建运行时所需表：

```sh
/opt/lampp/bin/mysql -u root -p mypassword < /opt/lampp/htdocs/mina_auth/system/db/db.sql
```
   
## 初始化 appId 和 appSecret

登录到 MySql 后，手动插入配置到 `cAuth` 表中。

```sh
/opt/lampp/bin/mysql -u root -p root #登录本地mysql
use cAuth;
insert into cAppinfo set appid='Your appid',secret='Your secret';
```
    
### 测试服务可用性

```sh
curl -i -d'{"version":1,"componentName":"MA","interface":{"interfaceName":"qcloud.cam.id_skey","para":{"code":"001EWYiD1CVtKg0jXGjD1e6WiD1EWYiC","encrypt_data":"DNlJKYA0mJ3+RDXD/syznaLVLlaF4drGzeZvJFmjnEKtOAi37kAzC/1tCBr7KqGX8EpiLuWl8qt/kcH9a4LxDC5LQvlRLJlDogTEIwtlT/2jBWBuWwBC3vWFhm7Uuq5AOLZV+xG9UmWPKECDZX9UZpWcPRGQpiY8OOUNBAywVniJv6rC2eADFimdRR2qPiebdC3cry7QAvgvttt1Wk56Nb/1TmIbtJRTay5wb+6AY1H7AT1xPoB6XAXW3RqODXtRR0hZT1s/o5y209Vcc6EBal5QdsbJroXa020ZSD62EnlrOwgYnXy5c8SO+bzNAfRw59SVbI4wUNYz6kJb4NDn+y9dlASRjlt8Rau4xTQS+fZSi8HHUwkwE6RRak3qo8YZ7FWWbN2uwUKgQNlc/MfAfLRcfQw4XUqIdn9lxtRblaY="}}}' http://127.0.0.1/mina_auth/
```
    
    
