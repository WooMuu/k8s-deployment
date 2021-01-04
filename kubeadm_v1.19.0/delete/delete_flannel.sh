#!/bin/bash

set -e
#1、在主节点，找到之前的flannel yaml 的文件，执行：
kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#2、在每个节点，删除cni配置文件。需要重启机器
rm -rf /etc/cni/net.d/*
reboot
#3、重启kubelet ，不行的话重启服务器 reboot
systemctl restart kubelet

#然后查看  flannel已经消失
kubectl get pod -n kube-system

