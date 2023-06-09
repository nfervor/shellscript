#!/bin/bash
#将同目录下的字幕文件名替换成视频文件名+zh-cn等格式的字幕文件名，实现plex等媒体软件可以正确匹配字幕语言

# 设置要处理的目录路径
directory=$(pwd)

#字幕语言命令规则
lang_subtitle=".zh-cn"

# 遍历目录下的所有文件
for file in "$directory"/*; do
  # 检查文件是否是常规文件
  if [ -f "$file" ]; then
    # 检查文件扩展名是否为视频文件名模式中指定的格式
    if [[ "${file,,}" =~ .*\.(mkv|avi|mp4)$ ]]; then ## {$file,,} 将文件名字符串转换为小写，{$file^^} 转换为大写
    # if [[ "$file" == *.mkv || "$file" == *.avi || "$file" == *.mp4 ]]; then
      # 提取文件名，不包括扩展名
      filename=$(basename -- "$file")
      filename="${filename%.*}"
      # 构造新的字幕文件名
      for subtitle_file in "$directory"/*; do
        # 检查文件扩展名是否为字幕文件名模式中指定的格式
        if [[ "${subtitle_file,,}" == *.srt || "${subtitle_file,,}" == *.ass ]]; then
          subtitle_extension="${subtitle_file##*.}"  # 获取字幕文件的扩展名
          new_filename="$filename$lang_subtitle.$subtitle_extension"   # 应用字幕文件的扩展名
          # 检查是否存在同名的字幕文件
          if [ -e "$directory/$new_filename" ]; then
            echo "错误：$directory/$new_filename 文件已经存在，请手动处理"
          else
            mv "$subtitle_file" "$directory/$new_filename"
            echo "将 $subtitle_file 重命名为 $directory/$new_filename"
          fi
        fi
      done
    fi
  fi
done