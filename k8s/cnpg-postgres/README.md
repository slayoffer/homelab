# Source: https://gist.github.com/vfarcic/8301efb15748af1da3e376b7132e519e

###################################################################
# Should We Run Databases In Kubernetes? CloudNativePG PostgreSQL #
# https://youtu.be/Ny9RxM6H6Hg                                    #
###################################################################

# Additional Info:
# - CloudNativePG: https://cloudnative-pg.io
# - EDB: https://enterprisedb.com

#########
# Setup #
#########

# Create a Kubernetes cluster

helm repo add cnpg https://cloudnative-pg.github.io/charts

helm repo add prometheus-community \
  https://prometheus-community.github.io/helm-charts

helm repo update

helm upgrade --install cnpg cnpg/cloudnative-pg \
    --namespace cnpg-system --create-namespace --wait

helm upgrade --install prometheus-community \
    prometheus-community/kube-prometheus-stack \
    --namespace observability --create-namespace \
    --values https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/kube-stack-config.yaml \
    --wait

kubectl --namespace observability apply \
    --filename https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/grafana-configmap.yaml

git clone https://github.com/vfarcic/cloud-native-pg-demo

cd cloud-native-pg-demo

kubectl create namespace demo

########################################################
# Running PostgreSQL In Kubernetes Using CloudNativePG #
########################################################

cat cluster.yaml

kubectl --namespace demo apply --filename cluster.yaml

kubectl --namespace demo get clusters

kubectl --namespace demo get pods

kubectl --namespace demo get statefulsets

kubectl --namespace demo get services

kubectl --namespace demo get secrets

kubectl --namespace demo get clusters

kubectl --namespace observability port-forward \
    service/prometheus-community-grafana 8080:80

# Open http://localhost:8080 in a browser

# Use `admin` as the username and `prom-operator` as the password

# Open https://cloudnative-pg.io/documentation/1.20/samples/cluster-example-full.yaml

###########
# Destroy #
###########

# Press Ctrl+C to stop port forwarding
# Destroy or reset the cluster