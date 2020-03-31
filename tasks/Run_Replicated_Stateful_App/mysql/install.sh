#!/usr/bin/env bash
set -e
kubectl apply -f ./mysql-configmap.yaml
kubectl apply -f ./mysql-services.yaml

kubectl apply -f ./mysql-storageClass.yaml
#创建pv
kubectl apply -f ./mysql-pv.yaml
kubectl apply -f ./mysql-statefulset.yaml