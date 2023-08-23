#!bin/bash
#检查网盘挂载服务是否正在运行，非运行状态则启动运行命令并使用bark推行运行结果

#onedriveluli对应rclone.service
#onedrivechosen对应rclone1.service
MOUNT_NETWORK_DISK1="onedriveluli"
MOUNT_NETWORK_DISK2="onedrivechosen"
SERVICE_NAME1="rclone"
SERVICE_NAME2="rclone1"
SERVICE_NAME=(${SERVICE_NAME1} ${SERVICE_NAME2})

BARK_SERVER="http://23.234.231.177:8088"
BARK_KEY="gSELm6PsZnwDRKKzxkmPRk"
BARK_ICON1="https://raw.githubusercontent.com/nfervor/task/main/icons/data-science.png"
BARK_ICON2="https://raw.githubusercontent.com/nfervor/task/main/icons/pc-tower.png"

BARK_PUSH() {
    curl -X "POST" "${BARK_SERVER}/push" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
   "body": "'"$1"'",
   "title": "'"$2"'",
   "device_key": "'"${BARK_KEY}"'",
   "level": "active",
   "icon": "'"$3"'",
   "group": "'"$4"'"
 }'
}

for i in "${SERVICE_NAME[@]}"; do
 if [[ ! $(systemctl is-active "${i}") = "active" ]]; then
   systemctl start "${i}"
    if [[ $(systemctl is-active "${i}") = "active" ]]; then
      BARK_PUSH "MOUNT_SUCCEED" "${i^^}" "${BARK_ICON1}" "BUYVM_PUSH"
     else
      BARK_PUSH "MOUNT_ERR" "${i^^}" "${BARK_ICON2}" "BUYVM_PUSH"
    fi
  fi
done
