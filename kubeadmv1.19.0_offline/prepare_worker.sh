#!/bin/bash
set -e

mkdir /root/k8sOfflineSetup
tar -xzvf /root/k8sOfflineSetup.tar.gz -C /root/k8sOfflineSetup

# worker节点的主机名
export HOSTNAME=k8s-worker1
# kubernetes apiserver的主机地址
export APISERVER_NAME=apiserver.k8s.com
# 集群中master节点的ip地址
export MASTER_IP=192.168.254.4
# 加入master的token
export TOKEN=9ksyly.ynz2iafd6lm3lfse
# 加入master的证书
export CERT=sha256:5c4e9c3fe3a35f11564ed3027ad8c8912de64f78e4e85dcda7c92e49ab28c7b3
cd /root/k8sOfflineSetup
./setup_worker.sh