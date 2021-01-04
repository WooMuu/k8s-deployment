#!/bin/bash
set -e
#添加kubernetes源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
#刷缓存
yum clean all
yum makecache -y
yum repolist all

#查看历史版本有那些
yum list --showduplicates kubeadm|grep 1.19
#本地下载rpm包
yum install  kubectl-1.19.0 kubeadm-1.19.0 kubelet-1.19.0  --downloadonly --downloaddir=./rpmKubeadm

yum install kubeadm-1.19.0 -y