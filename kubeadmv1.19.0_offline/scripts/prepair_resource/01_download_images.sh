#!/bin/bash
set -e
#/bin/bash
KUBE_VERSION=v1.19.0

GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.aliyuncs.com/google_containers

images=(`kubeadm config images list --kubernetes-version=$KUBE_VERSION|awk -F '/' '{print $2}'`)

for imagename in ${images[@]} ; do
  echo $imagename
  echo "docker pull $ALIYUN_URL/$imagename"
  docker pull $ALIYUN_URL/$imagename
  docker tag  $ALIYUN_URL/$imagename $GCR_URL/$imagename
  docker rmi $ALIYUN_URL/$imagename
done

images=(`kubeadm config images list --kubernetes-version=$KUBE_VERSION`)
echo "docker save ${images[@]} -o kubeDockerImage$KUBE_VERSION.tar"
docker save ${images[@]} -o kubeDockerImage$KUBE_VERSION.tar
docker images