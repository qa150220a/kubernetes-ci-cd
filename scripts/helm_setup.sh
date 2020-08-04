#! /bin/bash -e
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh; chmod 700 get_helm.sh; ./get_helm.sh

helm init
kubectl rollout status deploy/tiller-deploy -n kube-system

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
helm init --service-account tiller --upgrade
helm list
helm install stable/etcd-operator --name etcd-operator --namespace kube-system --debug --wait

