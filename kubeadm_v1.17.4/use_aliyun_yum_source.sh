#!/bin/bash
set -e
yum install wget -y
#1、备份
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
cp -p ./CentOS7-Aliyun.repo /etc/yum.repos.d
cp -p ./epel-7-Aliyun.repo /etc/yum.repos.d

yum clean all
yum makecache -y
yum repolist all
