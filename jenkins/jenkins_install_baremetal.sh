#!/usr/bin/env bash
set -e
echo "###############################################"
echo "Minimum hardware requirements:"
echo "256 MB of RAM    1 GB of drive space "
#设置国内yum源
././../kubeadm_v1.17.4/use_aliyun_yum_source.sh
#检查并jdk
if  [ ! $(rpm -qa | grep $1) ]; then
    echo "$1 is not  installed"
else
    echo "$1 is  installed"
fi
#检查并安装weget
sudo yum -y install wget
sudo yum -y install setup
sudo yum -y install perl
#安装Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum -y upgrade
sudo yum -y install jenkins java-1.8.0-openjdk-devel
#启动Jenkins
sudo systemctl start jenkins
#设置开机启动
#sudo service enable jenkins 不对
#查看状态
sudo systemctl status jenkins
