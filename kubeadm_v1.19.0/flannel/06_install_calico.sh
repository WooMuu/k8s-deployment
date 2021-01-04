#!/bin/bash
set -e
# calico安装地址  https://docs.projectcalico.org/getting-started/kubernetes/quickstart
#1. 先下载Calico的manifest文件。
curl https://docs.projectcalico.org/manifests/tigera-operator.yaml -O
curl https://docs.projectcalico.org/manifests/custom-resources.yaml -O
#需要根据kubeadm init 的参数--pod-network-cidr值修改custom-resources.yaml的CALICO_IPV4POOL_CIDR的值
#2.下载所需镜像
cat tigera-operator.yaml |grep image
cat custom-resources.yaml |grep image

#3.安装calico
kubectl apply -f tigera-operator.yaml
kubectl apply -f custom-resources.yaml

#4.查看calico pod安装状态
watch kubectl get pods -n calico-system

# Wait a while to let network takes effect
sleep 30
k8s_health_check.sh
