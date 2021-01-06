

## 来自于我的CSDN https://blog.csdn.net/m0_37806791/article/details/112234276

 - # 网络拓扑
 
HAproxy+keepalive+Kubeadm安装Kubernetes master

 - #  机器信息
| 主机名 | ip地址 | 作用|
|-|--|--|
|k8s-master01|192.168.254.3|Kubernetes master/etcd,keepalive(主)，HAproxy|
|k8s-master02|192.168.254.4|Kubernetes master/etcd,keepalive(主)，HAproxy|
|k8s-master03|192.168.254.5|Kubernetes master/etcd,keepalive(主)，HAproxy|
|  /| 192.168.254.8 | VIP(虚拟IP) |

## 系统初始化
 1. 添加host解析

```bash
cat >> /etc/hosts<<EOF
192.168.254.3  k8s-master01
192.168.254.4  k8s-master02
192.168.254.5  k8s-master03
192.168.254.8   cluster.kube.com
EOF

hostnamectl set-hostname k8s-master01 //永久修改hostname
```

 2. 时间同步，修改语言

```bash
timedatectl set-timezone Asia/Shanghai
yum install -y ntpdate
ntpdate -u ntp.api.bz
echo 'LANG="en_US.UTF-8"' >> /etc/profile;source /etc/profile #修改系统语言
```
 3. 所有节点必须关闭防火墙及swap

```bash
setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config # 关闭selinux
systemctl stop firewalld.service && systemctl disable firewalld.service # 关闭防火墙
cp -p /etc/fstab /etc/fstab.bak$(date '+%Y%m%d%H%M%S')
sed -i "s/\/dev\/mapper\/rhel-swap/\#\/dev\/mapper\/rhel-swap/g" /etc/fstab
sed -i "s/\/dev\/mapper\/centos-swap/\#\/dev\/mapper\/centos-swap/g" /etc/fstab
swapoff -a
#如果修改/etc/fstab里的swap相关信息，需要重启
```
 4. 性能调优

```bash
cat >> /etc/sysctl.conf<<EOF
net.ipv4.ip_forward=1
net.ipv4.ip_nonlocal_bind = 1
EOF
sysctl -p
```
 5. 配置免密登录
各master节点执行：
```bash
ssh-keygen -t rsa //一路回车
ssh-copy-id -i ~/.ssh/id_rsa.pub root@k8s-master01
ssh-copy-id -i ~/.ssh/id_rsa.pub root@k8s-master02
ssh-copy-id -i ~/.ssh/id_rsa.pub root@k8s-master03
```
## 部署keepalived
 1. k8s-master01 install keepalive and HAproxy:

```bash
yum -y install epel-re*
yum -y install keepalived.x86_64
#设置环境变量
#STATE=master
#INTERFACE=ens33
#ROUTER_ID=51
#PRIORITY=150
#AUTH_PASS=ticp
#APISERVER_VIP=192.168.254.8
#把占位字母换成上面的变量
cat > /etc/keepalived/keepalived.conf << EOF
! Configuration File for keepalived
global_defs {
    router_id LVS_DEVEL
}
vrrp_script check_apiserver{
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  weight -2
  fall 10
  rise 2
}


vrrp_instance VI_1 {
    state ${STATE}
    interface ${INTERFACE}
    virtual_router_id ${ROUTER_ID}
    priority ${PRIORITY}
    authentication {
        auth_type PASS
        auth_pass ${AUTH_PASS}
    }
    virtual_ipaddress {
        ${APISERVER_VIP}
    }
    track_script {
        check_apiserver
    }
EOF
systemctl enable keepalived.service && systemctl start keepalived.service
```

 2. check_apiserver.sh脚本范例：

```bash
#占位符示例
#APISERVER_DEST_PORT=6443
#APISERVER_VIP=192.168.254.8
#把占位字母换成上面的变量
cat > /etc/keepalived/check_apiserver.sh<<-'EOF'
#!/bin/sh

errorExit() {
    echo "*** $*" 1>&2
    exit 1
}


curl --silent --max-time 2 --insecure https://localhost:${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET https://localhost:${APISERVER_DEST_PORT}/"
if ip addr | grep -q ${APISERVER_VIP}; then
    curl --silent --max-time 2 --insecure https://${APISERVER_VIP}:${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET https://${APISERVER_VIP}:${APISERVER_DEST_PORT}/"
fi
EOF
```

 3. k8s-master02和 k8s-master03

参照以上脚本执行，只修改脚本的STATE（MASTER和BACKUP）和PRIORITY

 4. 检查Keepalived状态

```bash
systemctl status keepalived.service
ip a | grep ${APISERVER_VIP}
```

## 部署HAproxy

所有Kubernetes cluster master节点 install HAproxy:

```bash
yum -y install haproxy.x86_64
cat > /etc/haproxy/haproxy.cfg <<-'EOF'
#---------------------------------------------------------------------# Global settings#---------------------------------------------------------------------
global
    log /dev/log local0
    log /dev/log local1 notice
    daemon


#---------------------------------------------------------------------# common defaults that all the 'listen' and 'backend' sections will# use if not designated in their block#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 1
    timeout http-request    10s
    timeout queue           20s
    timeout connect         5s
    timeout client          20s
    timeout server          20s
    timeout http-keep-alive 10s
    timeout check           10s


#---------------------------------------------------------------------# apiserver frontend which proxys to the masters#---------------------------------------------------------------------
frontend apiserver
    bind *:6443
    mode tcp
    option tcplog
    default_backend apiserver


#---------------------------------------------------------------------# round robin balancing for apiserver#---------------------------------------------------------------------
backend apiserver
    option httpchk GET /healthz
    http-check expect status 200
    mode tcp
    option ssl-hello-chk
    balance     roundrobin
        server k8s-master01 192.168.254.3:6443 check
        server k8s-master02 192.168.254.4:6443 check
        server k8s-master03 192.168.254.5:6443 check
EOF
systemctl start haproxy.service  && systemctl enable haproxy.service

```

安装k8s
略...


