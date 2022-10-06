#!/bin/bash

# deletepagename -> $1

# git_url 경로문제로 삭제 안함

#-----------------------------------------------------------------#
rm -rf /home/vagrant/ingress/test/nginx-$1.yml
rm -rf /home/vagrant/ingress/test/$1

kubectl delete cm ${1}cm
kubectl delete deployment ${1}
kubectl delete svc ${1}

grep -n /${1} ~/ingress/test/ingress-config.yml | tail -1 > a.txt
d=`awk -F : '{print $1}' a.txt`
e=`expr $d + 6`
sed "$d, ${e}d" ~/ingress/test/ingress-config.yml > b.txt
cat b.txt > ~/ingress/test/ingress-config.yml
kubectl apply -f ~/ingress/test/ingress-config.yml
