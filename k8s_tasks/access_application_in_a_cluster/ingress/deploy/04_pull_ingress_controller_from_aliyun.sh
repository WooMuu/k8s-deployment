#!/bin/bash
set -e
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller:0.20.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller:0.20.0 quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.20.0
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller:0.20.0

docker pull registry.cn-hangzhou.aliyuncs.com/yuheng/defaultbackend-amd64:1.5
docker tag registry.cn-hangzhou.aliyuncs.com/yuheng/defaultbackend-amd64:1.5  k8s.gcr.io/defaultbackend-amd64:1.5
docker rmi registry.cn-hangzhou.aliyuncs.com/yuheng/defaultbackend-amd64:1.5

docker pull
docker tag
docker rmi

docker images

