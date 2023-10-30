#!/bin/bash
# 安装JDK 1.7 17.0.8.1
wget https://download.oracle.com/java/17/archive/jdk-17.0.8_linux-x64_bin.tar.gz
tar -xzf jdk-17.0.8_linux-x64_bin.tar.gz
rm jdk-17.0.8_linux-x64_bin.tar.gz
sudo mv jdk-17.0.8 /opt
echo 'export JAVA_HOME=/opt/jdk-17.0.8' >> ~/.bashrc
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc
source ~/.bashrc

# 安装Maven 3.6
wget https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xzf apache-maven-3.6.3-bin.tar.gz
rm -fr apache-maven-3.6.3-bin.tar.gz
sudo mv apache-maven-3.6.3 /opt
echo "export PATH=\$PATH:/opt/apache-maven-3.6.3/bin" >> ~/.bashrc
source ~/.bashrc

# 安装Docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# 添加当前用户到docker用户组
sudo usermod -aG docker $USER
# compose
sudo yum install -y epel-release
sudo yum install -y docker-compose

# 完成安装提示信息
echo "JDK 1.7、Maven 3.6和最新版本的Docker已成功安装！"
echo "请注销并重新登录以使更改生效。"

# 创建容器目录
mkdir /data/mysql/data  -p
mkdir /data/influxdb/data -p
mkdir /data/elasticsearch/data -p