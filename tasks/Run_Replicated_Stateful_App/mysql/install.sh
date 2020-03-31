#!/usr/bin/env bash
set -e
kubectl apply -f ./mysql-configmap.yaml
kubectl apply -f ./mysql-services.yaml
#创建pv
kubectl apply -f ./mysql-pv1.yaml
kubectl apply -f ./mysql-statefulset.yaml