#!/bin/bash

UPLOAD_DRIVE=
onedrive1="onedrivemedia" #nfervor onedrive
onedrive2="literone_media" #liter onedrive
# 定义阈值变量
threshold=95
flag=0

#检查挂载本地本地目录盘容量使用情况
 check_drive_availability(){
    for i in {1..5}; do
        for n in {1..2}; do
            indrect="onedrive${n}"
            onedrive=${!indrect} #间接引用变量
            used=$(df -h | grep "${onedrive}${i}:" | awk '{print $5}')
            if [[ -n ${used} ]]; then # 如果用量不为空，则输出用量信息
                echo "${onedrive}${i}:${used}"
                if [[ "${used%*%}" -lt ${threshold} ]]; then # 提取用量不含%的数值，使用阈值变量进行比较
                    echo "${onedrive}${i} is avaiable"
                    UPLOAD_DRIVE="${onedrive}${i}"
                    flag=1  # 设置标志变量为真
                    break  # 跳出内层循环
                else
                    echo "${onedrive}${i} is not available"
                fi
            else 
                echo "${onedrive}${i} not found"
            fi
        done
        if [ ${flag} -eq 1 ]; then
            break  # 根据标志变量判断是否跳出最外层循环
        fi 
    done
}

capacity=5 #Drive 总容量大小
CONVERT(){
    #首先将字节数量存储在变量 bytes 中。然后通过将字节数除以相应的转换因子来将其转换为不同的单位。注意，`bc` 是一个用于执行数学运算的命令行计算器，`scale=2` 用于指定结果保留两位小数。

    # Calculate used perctent
    used=$(echo "scale=0; $1 * 100 / $capacity / (1024 ^ 4)" | bc)
    echo "$2 is used $used"

    # Convert bytes to MiB
    mib=$(echo "scale=2; $1 / 1024 / 1024" | bc)
    echo "$2 is approximately $mib MiB"

    # Convert bytes to GiB
    gib=$(echo "scale=2; $1 / 1024 / 1024 / 1024" | bc)
    echo "$2 is approximately $gib GiB"

    # Convert bytes to TiB
    tib=$(echo "scale=2; $1 / 1024 / 1024 / 1024 / 1024" | bc)
    echo "$2 is approximately $tib TiB"
}

#检查rclone挂载盘容量使用情况，不管是否挂载到本地目录
calculate_drive_usage(){
    for i in {1..5}; do
        for n in {1..2}; do
            indrect="onedrive${n}"
            onedrive=${!indrect}
            used=$(rclone size "${onedrive}${i}:" | grep 'Total size:' | awk '{gsub(/[()]/, ""); print $5}') #这个命令将输出传递给awk，在包含"Total size:"的行上进行搜索。然后，使用gsub函数将括号(即(或者)都进行替换)和"GiB"字符串替换为空字符串，以消除括号和单位。最后，它打印出第四个字段，即字节数。
            if [[ -n ${used} ]]; then
                CONVERT "${used}" "${onedrive}${i}"
                echo "${onedrive}${i}:${used}"
            else
                echo "${onedrive}${i} not found"
            fi
        done
    done
}

calculate_drive_usage