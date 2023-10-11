#!/bin/bash

# 安装EPEL仓库
yum install -y epel-release

# 安装Nginx
yum install -y nginx

# 启动Nginx服务
systemctl start nginx

# 设置Nginx开机自启动
systemctl enable nginx

# 备份默认配置文件
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# 创建自定义配置文件
cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80;
    server_name example.com;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }

    location /nginx_status {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}
EOF

# 检查Nginx配置
nginx -t

# 重载Nginx配置
systemctl reload nginx

echo "Nginx安装和配置完成！"