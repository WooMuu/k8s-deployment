#!/bin/bash

set -e

./use_aliyun_kubernetes_yum_source.sh

setenforce 0
# Use Kubernetes-cni-0.6.0 explictly
# https://github.com/kubernetes/kubernetes/issues/75701
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Check installed Kubernetes packages
yum list installed | grep kube

systemctl enable kubelet && systemctl start kubelet

systemctl daemon-reload
systemctl restart kubelet
