使用kubeadm一键部署kubernetes集群

版本支持：
kubernetes  v1.19.0
docker-ce 19.03.8
Flannel network
CentOS7 64 bits

限制：

需要联网才能安装
以root用户运行
只支持创建单master+单etcd，还不支持master和etcd高可用
2 CPUs

下载源码：
https://github.com/FillixZhangJB/k8s-deployment.git

1、部署master节点
克隆（或复制）相应目录到master机器上，以root用户运行chmod u+x *.sh 。
一键部署kubernetes master:
./kubeadm_init_master.sh
运行完后，需要复制第5步kubeadm init 的输出的 kubeadm join 的内容，在下面的“部署kubernetes node”时会用到。

2、部署kubernetes node
克隆（或复制）相应目录到node机器上，以root用户运行chmod u+x *.sh 。
将上面kubeadm init 的输出中的kubeadm join 的内容放到kubeadm_join_node.sh的最后。
运行./kubeadm_join_node.sh 部署kubernetes node，并将该节点加入kubernetes集群。
如果忘记了kubeadm join 的内容，可以在Kubernetes master上执行下面的命令重新获得：
kubeadm token create --print-join-command




