#!/bin/bash
#将同目录下的字幕文件名替换成视频文件名+zh-cn等格式的字幕文件名，实现plex等媒体软件可以正确匹配字幕语言

# 设置要处理的目录路径
directory=$(pwd)

#字幕语言命令规则
lang_subtitle=".zh-cn"

# 用于电视节目sxxe0xx的匹配项
pattern="[sS][0-9]+[eE][0-9]+"

#重命名电视剧字幕
rename_series_subtitle(){
  # 提取文件名，不包括扩展名
  filename=$(basename -- "${file}")
  filename="${filename%.*}"
  # 提取文件中的sxxexx
  match=$(echo ${filename} | grep -oE ${pattern})

  # 构造新的字幕文件名
  for subtitle_file in "${directory}"/*; do
    # 检查文件扩展名是否为电视节目字幕文件名模式中指定的格式
    if [[ "${subtitle_file,,}" =~ .*\.(srt|ass)$ && "${subtitle_file,,}" =~ .*\.s[0-9]{2,}e[0-9]{2,}.*$ ]]; then
      if [[ echo "${subtitle_file,,}" | grep -q "${match,,}" ]]; then
        subtitle_extension="${subtitle_file##*.}"  # 获取字幕文件的扩展名
        new_filename="${filename}${lang_subtitle}.${subtitle_extension}"   # 应用字幕文件的扩展名

        # 检查是否存在同名的字幕文件
        if [ -e "${directory}/${new_filename}" ]; then
          echo "WARNING：${directory}/${new_filename} 字幕文件已存在"
        else
          mv "${subtitle_file}" "${directory}/${new_filename}"
          echo "将 ${subtitle_file} 重命名为 ${directory}/${new_filename}"
        fi
      fi
    fi
  done
}

#重命名电影字幕
rename_movies_subtitle(){
  # 提取文件名，不包括扩展名
  filename=$(basename -- "${file}")
  filename="${filename%.*}"
  
  # 构造新的字幕文件名
  for subtitle_file in "${directory}"/*; do
    # 检查文件扩展名是否为电影字幕文件名模式中指定的格式
    if [[ "${subtitle_file,,}" =~ .*\.(srt|ass)$ && ! "${subtitle_file,,}" =~ .*\.s[0-9]{2,}e[0-9]{2,}.*$ ]]; then
      subtitle_extension="${subtitle_file##*.}"  # 获取字幕文件的扩展名
      new_filename="${filename}${lang_subtitle}.${subtitle_extension}"   # 应用字幕文件的扩展名
      
      # 检查是否存在同名的字幕文件
      if [ -e "${directory}/${new_filename}" ]; then
        echo "WARNING：${directory}/${new_filename} 字幕文件已存在"
      else
        mv "${subtitle_file}" "${directory}/${new_filename}"
        echo "将 ${subtitle_file} 重命名为 ${directory}/${new_filename}"
      fi
    fi
  done
}

# 遍历目录下的所有文件
for file in "${directory}"/*; do
  # 检查文件是否是常规文件
  if [ -f "${file}" ]; then
    # echo "${file}"
    # 检查文件扩展名是否为电视节目视频文件名模式中指定的格式，${file,,} 将文件名字符串转换为小写，${file^^} 转换为大写
    if [[ "${file,,}" =~ .*\.(mkv|avi|mp4)$ && "${file,,}" =~ .*\.s[0-9]{2,}e[0-9]{2,}.* ]]; then 
      rename_series_subtitle
    # 检查文件扩展名是否为电影视频文件名模式中指定的格式，${file,,} 将文件名字符串转换为小写，${file^^} 转换为大写
    elif [[ "${file,,}" =~ .*\.(mkv|avi|mp4)$ && ! "${file,,}" =~ .*\.s[0-9]{2,}e[0-9]{2,}.*$ ]]; then 
      rename_movies_subtitle
    fi
  fi
done