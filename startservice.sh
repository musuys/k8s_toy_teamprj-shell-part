#!/bin/bash

a=nginx
b=1
# 시작하기 전에 ingress controller 배포해야함.

# $1 -> pagename, $2 -> gir url , $3 -> service
# nginx/http 배포
        if [ $1 -eq $b ] ;
        then
                if [ "$3" == "$a" ];
                then
                        mkdir /home/vagrant/ingress/test/default
                        cd /home/vagrant/ingress/test/default
                        #원래는 사용자에게 페이지 내용 받아야함
                        echo "default page-nginx" > index.html
                        kubectl create cm defaultcm --from-file index.html
                        kubectl apply -f /home/vagrant/ingress/test/nfs-nginx.yml

                else
                        mkdir /home/vagrant/ingress/test/default
                        cd /home/vagrant/ingress/test/default
                        #원래는 사용자에게 페이지 내용 받아야함
                        echo "default page-httpd" > index.html
                        kubectl create cm defaultcm --from-file index.html
                        kubectl apply -f ~/ingress/test/nfs-httpd.yml
                fi
        else if [ "$3" = "$a" ];
                then
                        mkdir /home/vagrant/ingress/test/$2
                        cd /home/vagrant/ingress/test/$2
                        #원래는 사용자에게 페이지 내용 받아야함
                        echo "$2 page-nginx" > index.html
                        kubectl create cm $2cm --from-file index.html
                        /home/vagrant/ingress/test/nginxmade.sh $1 $2
                        #ingress 파일에 추가
                        echo "
        - path: /$2
          pathType: Prefix
          backend:
            service:
              name: $2
              port:
                number: 80" >> /home/vagrant/ingress/test/ingress-config.yml
                else
                        mkdir /home/vagrant/ingress/test/$2
                        cd /home/vagrant/ingress/test/$2
                        echo "$2 page-http" > index.html
                        kubectl create cm $2cm --from-file index.html
                        /home/vagrant/ingress/test/httpmade.sh $1 $2  #ingress 파일에 추가
                        echo "
        - path: /$2
          pathType: Prefix
          backend:
            service:
              name: $2
              port:
                number: 80" >> /home/vagrant/ingress/test/ingress-config.yml
                fi
        fi
kubectl apply -f /home/vagrant/ingress/test/ingress-config.yml
