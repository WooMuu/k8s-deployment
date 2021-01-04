#!/bin/bash
set -e
# Uninstall installed docker
sudo yum -y remove docker \
                  docker-ce \
                  docker-ce-cli \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine


# Set up repository
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Use Aliyun Docker
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo


# Install a validated docker version
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.13.md#external-dependencies
yum install -y \
  containerd.io-1.2.10 \
  docker-ce-19.03.4 \
  docker-ce-cli-19.03.4

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "registry-mirrors": ["https://5twf62k1.mirror.aliyuncs.com"]
}
EOF

systemctl enable docker
systemctl start docker
docker version

# Use Aliyun docker registry
use_aliyun_docker_registry.sh

