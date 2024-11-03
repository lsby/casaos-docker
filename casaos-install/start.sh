#!/bin/bash

# 因为 docker 使用 system 有很多问题, 这里换成手动启动
# 原始的 system 配置在 bak/casaos-service 文件夹中
# 这个文件按这些配置文件定义的启动关系, 按顺序启动了这些服务

echo "启动 docker..."
dockerd &

echo "启动 rclone..."
/usr/bin/mkdir -p /var/run/rclone  && /usr/bin/rm -f /var/run/rclone/rclone.sock && /usr/bin/rclone rcd --rc-addr unix:///var/run/rclone/rclone.sock --rc-no-auth --rc-allow-origin "*" &

echo "启动 casaos 服务..."

# 原始的 system 服务单元 中定义的 服务类型 都是 notify
# 这意味着当服务启动后, 会通知 system
# 我查看了源码, 调用同时 system 的函数后, 会根据返回值打印不同的日志, 没有用 system 启动的日志是下面这句
# 所以这里用这句来判断服务已启动
SEARCH_STRING="This process is not running as a systemd service."

NAME="casaos-gateway"
LOG_PATH="/var/log/$NAME.log"
rm -rf $LOG_PATH && echo "" > $LOG_PATH
/usr/bin/"$NAME" > "$LOG_PATH" 2>&1 &
while ! grep -q "$SEARCH_STRING" "$LOG_PATH"; do
    echo "等待 $NAME 启动"
    echo "目前日志文件的最后一行是:"
    tail -n 1 $LOG_PATH
    sleep 1
done

NAME="casaos-message-bus"
LOG_PATH="/var/log/$NAME.log"
rm -rf $LOG_PATH && echo "" > $LOG_PATH
/usr/bin/"$NAME" -c /etc/casaos/message-bus.conf > "$LOG_PATH" 2>&1 &
while ! grep -q "$SEARCH_STRING" "$LOG_PATH"; do
    echo "等待 $NAME 启动"
    echo "目前日志文件的最后一行是:"
    tail -n 1 $LOG_PATH
    sleep 1
done

NAME="casaos-user-service"
LOG_PATH="/var/log/$NAME.log"
rm -rf $LOG_PATH && echo "" > $LOG_PATH
/usr/bin/"$NAME" -c /etc/casaos/user-service.conf > "$LOG_PATH" 2>&1 &
while ! grep -q "$SEARCH_STRING" "$LOG_PATH"; do
    echo "等待 $NAME 启动"
    echo "目前日志文件的最后一行是:"
    tail -n 1 $LOG_PATH
    sleep 1
done

NAME="casaos-app-management"
LOG_PATH="/var/log/$NAME.log"
rm -rf $LOG_PATH && echo "" > $LOG_PATH
/usr/bin/"$NAME" -c /etc/casaos/app-management.conf > "$LOG_PATH" 2>&1 &
while ! grep -q "$SEARCH_STRING" "$LOG_PATH"; do
    echo "等待 $NAME 启动"
    echo "目前日志文件的最后一行是:"
    tail -n 1 $LOG_PATH
    sleep 1
done

NAME="casaos"
LOG_PATH="/var/log/$NAME.log"
rm -rf $LOG_PATH && echo "" > $LOG_PATH
/usr/bin/"$NAME" -c /etc/casaos/casaos.conf > "$LOG_PATH" 2>&1 &
while ! grep -q "$SEARCH_STRING" "$LOG_PATH"; do
    echo "等待 $NAME 启动"
    echo "目前日志文件的最后一行是:"
    tail -n 1 $LOG_PATH
    sleep 1
done

NAME="casaos-local-storage"
LOG_PATH="/var/log/$NAME.log"
rm -rf $LOG_PATH && echo "" > $LOG_PATH
/usr/bin/"$NAME" -c /etc/casaos/local-storage.conf > "$LOG_PATH" 2>&1 &
while ! grep -q "$SEARCH_STRING" "$LOG_PATH"; do
    echo "等待 $NAME 启动"
    echo "目前日志文件的最后一行是:"
    tail -n 1 $LOG_PATH
    sleep 1
done

echo "Running self-check..."

CASA_SERVICES=(
    "casaos-gateway.service"
    "casaos-message-bus.service"
    "casaos-user-service.service"
    "casaos-local-storage.service"
    "casaos-app-management.service"
    "rclone.service"
    "casaos.service"
)

echo "所有服务均已启动!"

tail -f \
    /var/log/casaos-gateway.log \
    /var/log/casaos-message-bus.log \
    /var/log/casaos-user-service.log \
    /var/log/casaos-app-management.log \
    /var/log/casaos.log \
    /var/log/casaos-local-storage.log
