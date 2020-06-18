#!/bin/bash
set -e

mkdir /root/k8sOfflineSetup
tar -xzvf /root/k8sOfflineSetup.tar.gz -C /root/k8sOfflineSetup



# worker节点的主机名
export HOSTNAME=k8s-worker2
# kubernetes apiserver的主机地址
export APISERVER_NAME=apiserver.k8s.com
# 集群中master节点的ip地址
export MASTER_IP=192.168.254.135
# 加入master的token
export TOKEN=35jn30.4ru763yqfvp4j89m
# 加入master的证书
export CERT=sha256:4c720c8dbf3f91a542ee892188108f99ff80ba1025099a8210145917b1f13a13
cd /root/k8sOfflineSetup
./setup_worker.sh