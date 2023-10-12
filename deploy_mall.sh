#!/usr/bin/env bash
# 安装验证码需要的字体
yum install fontconfig
fc-cache --force
# 预定义脚本 springboot启动application.yml中使用
DB_IP=127.0.0.1
SERVICE_IP=8.140.32.229
export mysql_host=$DB_IP
export redis_host=$DB_IP
export mysql_user=test
# Docker container 命名
if [ -n "$1" ] ;then
  export app_name=$1
else
  export app_name=newbee
fi

if [ -n "$2" ] ;then
  export export_port=$2
else
  export export_port=28079
fi
export server_url=http://$SERVICE_IP:$export_port

if [ -n "$3" ] ;then
  export agent_port=$3
else
  export agent_port=$(printf "%04d" $((RANDOM % 10000)))
fi

echo "container app_name : $app_name"
echo "container port: $export_port"
echo "container agent_port: $agent_port"

## Maven 编译
mvn clean install -Dmaven.test.skip=true

## kill 发布端口的 进程
# 查找占用指定端口的进程ID
PID=$(netstat -tuln | grep $export_port | awk '{print $7}' | cut -d '/' -f 1)

# 检查是否找到了进程ID
if [[ -z $PID ]]; then
  echo "未找到占用端口 $PORT 的进程"
else
  # 杀死找到的进程ID
  echo "正在杀死进程 ID: $PID"
  sudo kill -9 $PID
  echo "进程已被杀死"
fi
echo "--->解压文件"
unzip -o upload.zip -d ~/
# 启动 springboot应用
echo "--->开始启动"

nohup java -Xms512m -Xmx512m -Duser.timezone=GMT+8 -Dfile.encoding=utf-8 \
  -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:1000 \
  -javaagent:./skywalking-agent/skywalking-agent.jar \
  -Dskywalking.agent.service_name=$app_name \
  -Dskywalking.agent.instance_name=$app_name-$export_port \
  -Dskywalking.collector.backend_service=$DB_IP:11800 \
  -jar ./target/newbee-mall-plus.jar --server.port=$export_port \
  >>/dev/null 2>&1 &
#java -Xms512m -Xmx512m -Duser.timezone=GMT+8 -Dfile.encoding=utf-8 \
#  -javaagent:./skywalking-agent/skywalking-agent.jar \
#  -Dskywalking.agent.service_name=$app_name \
#  -Dskywalking.collector.backend_service=$DB_IP:11800 \
#  -jar ./target/newbee-mall-plus.jar --server.port=$export_port