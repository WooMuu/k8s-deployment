#!/bin/bash
set -e
# Pre-configure
01_pre_check_and_configure.sh
# Install Docker
02_install_docker.sh
# Install kubelet kubeadm kubectl
03_install_kubernetes.sh
# Pull kubernetes images
04_pull_kubernetes_images_from_aliyun.sh
# Initialize k8s master
05_kubeadm_init.sh
# Install  flannel Pod network
./06_install_flannel.sh
#Remove the taints on the master so that you can schedule pods on it.
kubectl taint nodes --all node-role.kubernetes.io/master-

