#!/bin/bash
echo "###############################################"
echo "Please ensure your OS is CentOS7 64 bits"
echo "Please ensure your machine has full network connection and internet access"
echo "Please ensure run this script with root user"
echo "The following table lists the minimum and recommended hardware configurations for deploying Harbor.

    	    Minimum<-->Recommended
         CPU	2 CPU	4 CPU
         Mem	4 GB	8 GB
         Disk  40GB	 160 GB"
echo "Harbor requires that the following ports be open on the target host: HTTPS 443 HTTPS 4443  HTTP 80"
res=`docker-compose --version`
i=`./str.sh AcontainsB $res 'version'`
if [[ $i -eq 1 ]]
then
echo 已安装docker-compose
else
echo 未安装docker-compose
fi