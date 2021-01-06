#!/bin/bash
set -e
#images=(`kubeadm config images list --kubernetes-version=$KUBE_VERSION`)
images=(`docker images --format "{{.Repository}}:{{.Tag}}"`)
echo "docker save ${images[@]} -o kubeDockerImage$KUBE_VERSION.tar"
docker save ${images[@]} -o kubeDockerImage$KUBE_VERSION.tar
docker images