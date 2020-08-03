#! /bin/bash -e
sudo docker build -t 127.0.0.1:30400/hello-kenzan:latest -f applications/hello-kenzan/Dockerfile applications/hello-kenzan
sudo docker push 127.0.0.1:30400/hello-kenzan:latest
kubectl apply -f applications/hello-kenzan/k8s/manual-deployment.yaml
#kubectl describe svc hello-kenzan
IP=$(kubectl describe svc hello-kenzan | sed -n 's/^IP: *//p')
curl http://$IP
kubectl delete service hello-kenzan
kubectl delete deployment hello-kenzan
