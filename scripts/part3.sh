#! /bin/bash -e

kubectl  create -f manifests/etcd-cluster.yaml
kubectl  create -f manifests/etcd-service.yaml
kubectl apply -f manifests/all-services.yaml
sudo docker build -t 127.0.0.1:30400/monitor-scale:`git rev-parse --short HEAD` -f applications/monitor-scale/Dockerfile applications/monitor-scale
sudo docker push 127.0.0.1:30400/monitor-scale:`git rev-parse --short HEAD`
kubectl apply -f manifests/monitor-scale-serviceaccount.yaml
sed 's#127.0.0.1:30400/monitor-scale:$BUILD_TAG#127.0.0.1:30400/monitor-scale:'`git rev-parse --short HEAD`'#' applications/monitor-scale/k8s/deployment.yaml | kubectl apply -f -
kubectl rollout status deployment/monitor-scale
kubectl get pods
kubectl get services
kubectl get ingress
kubectl get deployments

./scripts/puzzle.sh
kubectl rollout status deployment/puzzle
kubectl rollout status deployment/mongo

./scripts/kr8sswordz-pages.sh
kubectl rollout status deployment/kr8sswordz
kubectl get pods
