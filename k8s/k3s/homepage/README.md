helm repo add jameswynn https://jameswynn.github.io/helm-charts

helm install \
--create-namespace \
--namespace homepage \
homepage jameswynn/homepage -f /home/slayo/docker/homelab/k8s/k3s/homepage/Helm/values.yaml

k apply -f /home/slayo/docker/homelab/k8s/k3s/homepage/Manifest

helm upgrade \
--namespace homepage \
homepage jameswynn/homepage \
-f /home/slayo/docker/homelab/k8s/k3s/homepage/Helm/values.yaml

kubectl rollout restart deployment/homepage -n homepage

# to delete
helm delete homepage

