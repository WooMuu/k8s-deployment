#!/bin/bash

set -e

use_aliyun_kubernetes_yum_source.sh

# setenforce 0
str1=`/usr/sbin/sestatus -v`
str2=disabled
if [ ${str1##* } = $str2 ]
then echo SElinux had was disabled
else setenforce 0
fi
# Use Kubernetes-cni-0.6.0 explictly
# https://github.com/kubernetes/kubernetes/issues/75701
yum install -y kubelet-1.19.0 kubeadm-1.19.0 kubectl-1.19.0  kubernetes-cni-0.8.6 --disableexcludes=kubernetes

# Check installed Kubernetes packages
yum list installed | grep kube

systemctl enable kubelet && systemctl start kubelet

systemctl daemon-reload
systemctl restart kubelet
