#!/usr/bin/env bash
echo "请确保系统中安装了docker"
#拉取最新的镜像
docker pull jenkins/jenkins
 #创建文件夹
mkdir /home/jenkins
#查看文件权限
ls -nd /home/jenkins
#给uid为1000的权限
chown -R 1000:1000 /home/jenkins
docker run --name jenkins -p 8080:8080 -p 50000:50000 -v /home/jenkins:/var/jenkins_home jenkins/jenkins:latest
