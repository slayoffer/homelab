# Instructions
1. ```
helm install \
cert-manager jetstack/cert-manager \
--create-namespace \
--namespace cert-manager \
--set installCRDs=true

helm install \
reflector emberstack/reflector \
--create-namespace \
--namespace reflector
    ```
2. ```


helm install \
traefik traefik/traefik \
--create-namespace \
--namespace traefik \
-f /home/slayo/docker/homelab/k8s/K3S/CrowdSec/Traefik/Helm/values.yaml

helm delete traefik --namespace traefik

helm install \
traefik traefik/traefik \
--namespace traefik \
-f /home/slayo/docker/homelab/k8s/K3S/Traefik/values.yaml

helm upgrade \
traefik traefik/traefik \
--namespace traefik \
-f /home/slayo/dev/homelab/k8s/k3s/CrowdSec/Traefik/Helm/values.yaml

helm upgrade \
reflector emberstack/reflector \
--namespace reflector
- f /home/slayo/homelab/k8s/CrowdSec/Reflector/values.yaml

helm install \
crowdsec crowdsec/crowdsec \
--create-namespace \
--namespace crowdsec \
-f /home/slayo/docker/homelab/k8s/K3S/CrowdSec/CrowdSec/values.yaml
    ```