#!/bin/bash
set -e

mkdir /root/k8sOfflineSetup
tar -xzvf /root/k8sOfflineSetup.tar.gz -C /root/k8sOfflineSetup

# worker节点的主机名
export HOSTNAME=k8s-worker1
# kubernetes apiserver的主机地址
export APISERVER_NAME=apiserver.k8s.com
# 集群中master节点的ip地址
export MASTER_IP=192.168.254.133
# 加入master的token
export TOKEN=2zch2l.721fybitox274skx
# 加入master的证书
export CERT=sha256:8a6829ff0e57be02ab21ad3ac970267ff474289cd32649cc9e7884c4bf3dae07
cd /root/k8sOfflineSetup
./setup_worker.sh