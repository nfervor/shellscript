#!/bin/bash
#Create folders of artists name, move their songs to the specific floder

# 歌手名列表
#artists=("孙燕姿" "陈慧娴" "熊天平" "游鸿明" "郑秀文" "张雨生" "蔡依林" "张惠妹" "郭富城" "齐秦" "李克勤" "古天乐" "张卫健" "蔡琴" "陈小春" "杨千嬅" "古巨基" "许冠杰" "周杰伦" "王菲" "蔡健雅" "杨丞琳" "林俊杰" "田馥甄" "陈慧琳" "陈百强" "李玟")
artists=("周传雄" "许茹芸" "王杰" "张信哲" "梅艳芳" "五月天" "范晓萱" "谭咏麟" "费玉清" "郑智化" "容祖儿" "汪峰" "周迅" "谢霆锋" "张学友" "刘德华" "林子祥" "余文乐" "邓丽君" "杨坤" "陈奕迅" "张国荣" "罗大佑" "张柏芝" "孟庭苇" "张智霖" "伍佰" "戴佩妮" "许志安" "林忆莲" "梁朝伟" "周华健" "刘若英")

# 创建文件夹并移动文件
for artist in "${artists[@]}"; do
  # 检查目录是否已存在
  if [ ! -d "$artist" ]; then
    # 如果不存在，则创建文件夹
    mkdir -p "$artist"

    # 移动文件
    find ./华语*/ -type f -name "*$artist*" -print0 | xargs -0 -I {} mv {} ./$artist/
  # 这里可以添加进一步的操作，如下载歌手的歌曲等
  # 例如：curl -O "http://example.com/${artist}_songs.zip"
done
