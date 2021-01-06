## **离线安装Kubernetes in Centos7（多主多从）**
## 环境

 - CentOS Linux release 7.7.1908 (Core)
 - Docker 19.03.5
 - Kubernetes 1.19.0
 - Master01节点 192.168.254.3
 - Master02节点 192.168.254.4
 - Master03节点 192.168.254.5
 - Worker节点 192.168.254.6

注意：
查看centos版本：

```bash
cat /etc/redhat-release
```
## 安装前的准备
1. [Keepalived+HAproxy 实现High Availability Kubernetes clusters](https://blog.csdn.net/m0_37806791/article/details/112234276)
 2. 根据k8s官网的安装文档，在安装k8s之前，需要对系统做一些调整。我已经写了一个完成脚本，放在github上：[pre-check](https://github.com/FillixZhangJB/k8s-deployment/blob/master/kubeadmv1.17.1_offline/01_pre_check_and_configure.sh)
需要在每台机器上执行。
 3.  将离线资源包复制到每个节点的/root目录下
## 安装docker+k8s
```bash
cd /root/k8sOfflineSetup
chmod 777 install_k8s.sh
./ install_k8s.sh
```

## 初始化master-MASTER
在***master01***节点上执行。

⚠️注意：解压路径不能修改。
 2. 设置环境变量并初始化
```bash
# master节点的主机名
export HOSTNAME=k8s-master01
# kubernetes apiserver的主机地址
export APISERVER_NAME=cluster.kube.com
export APISERVER_DEST_PORT=16443
# 集群中master节点的ip地址（Keepalived的虚拟ip）
export MASTER_IP=192.168.254.100
# Pod 使用的网段
export POD_SUBNET=10.11.10.0/16

cd /root/k8sOfflineSetup
./setup_master-MASTER.sh
```
注意：

> MASTER_IP=192.168.254.100需要Keepalived的虚拟ip
> 记录下打印出的主节点和从节点加入集群的脚本。

## 初始化Worker
在***worker***节点上执行。
 1. 获取加入master的token
 
在master节点执行：
```bash
# 在 master 节点执行
kubeadm token create --print-join-command
```
 2. 设置环境变量
 
```bash
# worker节点的主机名
export HOSTNAME=k8s-worker1
export MASTER_IP=192.168.254.100
export APISERVER_NAME=cluster.kube.com
```
3. 将主节点集群的虚拟ip和域名加入hosts
```bash
hostnamectl set-hostname $HOSTNAME
echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts
```
4. 执行kubeadm join 命令
5. 在主节点为从节点设置角色

```bash
kubectl label nodes k8s-workder1 node-role.kubernetes.io/node=
```

## 验证：
到这里k8s多主多从集群已经安装好了，执行下面的命令查看集群的节点状态：

```bash
kubectl get nodes
```

正常情况下：

```bash
root@k8s-master02 k8sOfflineSetup]# kubectl get node
NAME           STATUS   ROLES    AGE     VERSION
k8s-master01   Ready    master   29h     v1.19.0
k8s-master02   Ready    master   28h     v1.19.0
k8s-master03   Ready    master   28h     v1.19.0
k8s-worker1    Ready    node     2m54s   v1.19.0

```

如果有点节点的status状态不是Ready,移步
[k8s官方文档的troubleshooting](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/)
[Minikube不能启动的原因](https://editor.csdn.net/md/?articleId=104900429)
## 访问Kuboard
Kuboard是一个非常方便的web管理界面，安装完以后可以通过http://任意节点IP:32567/访问。详细使用请参考 <www.kuboard.cn>
获取登陆Token：

```bash
# 在 Master 节点上执行此命令
kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep kuboard-user | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d
```


