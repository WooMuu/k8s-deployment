#!/bin/bash
set -e

mkdir /root/k8sOfflineSetup
tar -xzvf k8sOfflineSetup.tar.gz -C /root/k8sOfflineSetup
# master节点的主机名
export HOSTNAME=k8s-master
# kubernetes apiserver的主机地址
export APISERVER_NAME=apiserver.k8s.com
# 集群中master节点的ip地址
export MASTER_IP=192.168.254.133
# Pod 使用的网段
export POD_SUBNET=10.11.10.0/16

cd /root/k8sOfflineSetup
./setup_master.sh