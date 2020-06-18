## **离线安装Kubernetes in Centos7（一主多从）**
## 参考
参考了简书：https://www.jianshu.com/p/fd9f1076ea2d
离线资源包： - [ ] 暂时未上传
k8s部署脚本：[k8s-deployment](https://github.com/FillixZhangJB/k8s-deployment.git)
k8s官网安装：[k8s install](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
## 环境

 - CentOS Linux release 7.7.1908 (Core)
 - Docker 19.03.5
 - Kubernetes 1.17.1
 - Master节点 192.168.254.133
 - Worker节点 192.168.254.135

注意：
查看centos版本：

```bash
cat /etc/redhat-release
```
## 安装前的准备

 1. 根据k8s官网的安装文档，在安装k8s之前，需要对系统做一些调整。我已经写了一个完成脚本，放在github上：[pre-check](https://github.com/FillixZhangJB/k8s-deployment/blob/master/kubeadmv1.17.1_offline/01_pre_check_and_configure.sh)
需要在每台机器上执行。
 2.  将离线资源包复制到每个节点的/root目录下

## 安装master
在***master***节点上执行。

 1. 解压到/root/k8sOfflineSetup目录
 ```bash
mkdir /root/k8sOfflineSetup
tar -xzvf k8sOfflineSetup.tar.gz -C /root/k8sOfflineSetup 
```
⚠️注意：解压路径不能修改。
 2. 设置参数并安装
 

```bash

```bash
# master节点的主机名
export HOSTNAME=k8s-master
# kubernetes apiserver的主机地址
export APISERVER_NAME=apiserver.k8s.com
# 集群中master节点的ip地址
export MASTER_IP=192.168.1.30
# Pod 使用的网段
export POD_SUBNET=10.11.10.0/16

cd /root/k8sOfflineSetup
./setup_master.sh
```
注意：
MASTER_IP=192.168.1.30需要根据自己的机器ip做修改
## 安装Worker
在***worker***节点上执行。
 1. 获取加入master的token
 
在master节点执行：
```bash
# 在 master 节点执行
kubeadm token create --print-join-command
```
 2. 设置参数并安装
 

```bash
# worker节点的主机名
export HOSTNAME=k8s-worker2
# kubernetes apiserver的主机地址
export APISERVER_NAME=apiserver.k8s.com
# 集群中master节点的ip地址
export MASTER_IP=192.168.1.30
# 加入master的token
export TOKEN=35jn30.4ru763yqfvp4j89m
# 加入master的证书
export CERT=sha256:4c720c8dbf3f91a542ee892188108f99ff80ba1025099a8210145917b1f13a13
cd /root/k8sOfflineSetup
./setup_worker.sh
```
## 验证：
到这里k8s一主多从集群已经安装好了，执行下面的命令查看集群的节点状态：

```bash
kubectl get nodes
```
正常情况下，
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618175206688.png)
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


