#!/usr/bin/env bash
#下载镜像
docker pull registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
docker images
#创建容器
docker run -d -p 1521:1521 --name oracle11g registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
#启动容器
docker start oracle11g
#进入镜像进行配置
docker exec -it oracle11g bash
