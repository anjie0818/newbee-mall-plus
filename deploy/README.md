# 环境搭建步骤
## 【前置准备】安装docker、java、mvn
* 执行shell
## 监控+DB
* 创建挂在目录
  * /data/mysql/data
  * /data/influxdb/data
  * /data/elasticsearch/data
* 导入mysql数据
## 应用
* 执行shell
## nginx
* 执行shell
* 配置反向代理
## jmeter
### mvn+jmeter集成
### influence+grafana集成
```

upstream backend {
    server 127.0.0.1:28019;  # 第一个 Spring Boot 服务地址
    server 127.0.0.1:28019;  # 第二个 Spring Boot 服务地址
}

server {
    listen 80;
    server_name mall.com;  # 修改为您的域名或 IP 地址

    location / {
        proxy_pass http://backend;  # 将请求转发到 upstream 中定义的后端地址
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
    location /nginx_status {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}
    

```
## 肉鸡