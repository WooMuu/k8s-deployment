#!/bin/bash

set -e

pull_flannel_images_from_aliyun.sh


kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Wait a while to let network takes effect
sleep 30
k8s_health_check.sh
