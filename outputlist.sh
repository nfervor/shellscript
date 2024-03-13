#!/bin/bash

onedrive1="onedrivemedia" #nfervor onedrive
onedrive2="literone_media" #liter onedrive

for i in {1..5}; do
    for n in {1..2}; do
        indrect="onedrive${n}"
        onedrive=${!indrect} #间接引用变量
        echo "${onedrive}${i}:" >> onelist.txt
        rclone lsd "${onedrive}${i}:" >> onelist.txt
    done
done