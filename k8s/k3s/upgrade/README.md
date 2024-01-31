https://milindchawre.github.io/site/blog/k3s-upgrade-a-simplified-guide/

Install the system-upgrade-controller
The k3s cluster upgradation is handled by a controller named system-upgrade-controller which leverages a custom resource definition (CRD), the plan, and a controller that schedules upgrades based on the configured plans. This system-upgrade-controller need to be installed as a deployment in your k3s cluster. To install it run following command:

kubectl apply -f https://raw.githubusercontent.com/rancher/system-upgrade-controller/master/manifests/system-upgrade-controller.yaml

# For master nodes
kubectl label node k3s-01 k3s-master-upgrade=true
kubectl label node k3s-02 k3s-master-upgrade=true
kubectl label node k3s-03 k3s-master-upgrade=true
                   OR
# For worker nodes
kubectl label node k3s-04 k3s-worker-upgrade=true
kubectl label node k3s-05 k3s-worker-upgrade=true

# upgrade
k apply -f /home/slayo/homelab/k8s/k3s/upgrade/plans.yaml

# check
kubectl -n system-upgrade get jobs
kubectl get plans -n system-upgrade

# or with yaml
kubectl -n system-upgrade get plans -o yaml
kubectl -n system-upgrade get jobs -o yaml