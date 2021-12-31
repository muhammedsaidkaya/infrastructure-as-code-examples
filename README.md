
## Clone Repo

```
git clone https://github.com/muhammedsaidkaya/k8s-cluster-rancher-vault-setup
```

## Packer - AMI Creation for Bastion Host
```
cd packer-jump-rke-ansible
packer init
packer validate .
packer build .
```

## Terraform - High Available Provisioning 
```
cd provisioning
export TF_VAR_ec2_count=4
terraform init
terraform plan -out 'tfplan'
terraform apply 'tfplan'
```

## Ansible - Vanilla Cluster Configuration Management
```
cd configuration-vanilla-cluster
#Update host.ini, fill the blanks with master and worker nodes ip addresses
vi hosts.ini
ansible-playbook playbook.yaml
```

## Ansible - RKE-Rancher Configuration Management
```
cd configuration-rke-rancher-vault
#Update host.ini with jump ip
vi hosts.ini
#Update group_vars/all.yaml with private ips of nodes and rancher hostname
vi group_vars/all.yaml
ansible-playbook playbook.yaml 
```

## Manual - RKE-Rancher Configuration Management

### Copy SSH Key to Bastion Host

```
ssh ubuntu@{jump-ec2-public-ip}
vi /tmp/id_rsa
chmod 400 /tmp/id_rsa
```

### Ansible - K8s Cluster Setup (Run on Bastion Host)

#### Install Ansible 
```
sudo apt-get update
sudo apt install python3-pip --yes
pip3 install ansible
pip3 install Jinja2 --upgrade
export PATH="$(python3 -m site --user-base)/bin":$PATH
```

#### RKE Cluster 

```
git clone https://github.com/kloia/rke-ansible.git
cd rke-ansible
#Update node ip adresses
vi vars/general-config.yml
sh provision.sh
```

### Rancher Setup

#### Create Namespace 
```
kubectl create namespace cattle-system
```

#### Create cert-manager for self-signing certificates
```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

#### Install cert-manager
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.1
```

#### Install rancher with Helm
Note: Update hostname variable with your public ip. After installation, Go to your host and enter the password.
```
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm install rancher rancher-latest/rancher --namespace cattle-system \
  --set hostname={hostname-with-dash}.sslip.io	 \
  --set replicas=3
kubectl -n cattle-system get deploy rancher
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'
```

### Vault Setup

```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
cat <<EOF > helm-vault-values.yml
server:
  affinity: ""
  ha:
    enabled: true
EOF
helm install vault hashicorp/vault --values helm-vault-values.yml
cat <<EOF > pv.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /tmp
EOF
kubectl apply -f pv.yml
```

#### Vault Unseal-Login Part

##### Unseal Vault

```
kubectl exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
sudo apt-get install jq
cat cluster-keys.json | jq -r ".unseal_keys_b64[]"
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
```

##### Vault Login
```
cat cluster-keys.json | jq -r ".root_token"
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh
vault login
vault secrets enable -path=secret kv-v2
```

### Vault ServiceAccount-Policy-Role-Namespace Config for K8s

#### Store Secrets
```
vault kv put sockshop/database/config db="socksdb" password="fake_password"
vault kv get sockshop/database/config
```

#### Enable K8s
```
vault auth enable kubernetes
vault write auth/kubernetes/config \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
        issuer="https://kubernetes.default.svc.cluster.local"

```
#### Create Policy
``` 
vault policy write sockshop-policy - <<EOF
path "sockshop/data/database/config" {
  capabilities = ["read"]
}
EOF
```

#### Create ROLE
```
vault write auth/kubernetes/role/sockshop-role \
        bound_service_account_names=sockshop-sa \
        bound_service_account_namespaces=sock-shop \
        policies=sockshop-policy \
        ttl=24h
```

#### Create Namespace-ServiceAccount
```
kubectl create ns sock-shop
kubectl config set-context --current --namespace=sock-shop
kubectl create sa sockshop-sa
```

### SockShop App Setup

```
git clone https://github.com/microservices-demo/microservices-demo/
cd micoservices-demo/deploy/kubernetes/manifests
```
#### Creating Secret file with Vault-Agent and Exporting Environment Variables
```
cat <<EOF > 07-catalogue-db-dep.yaml 
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalogue-db
  labels:
    name: catalogue-db
  namespace: sock-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      name: catalogue-db
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: 'true'
        vault.hashicorp.com/role: 'sockshop-role'
        vault.hashicorp.com/agent-inject-secret-database-config.txt: 'sockshop/data/database/config'
        vault.hashicorp.com/agent-inject-template-database-config.txt: |
          {{- with secret "sockshop/data/database/config" -}}
           export MYSQL_ROOT_PASSWORD={{ .Data.data.password }}
           export MYSQL_DATABASE={{ .Data.data.db }}
          {{- end -}}
      labels:
        name: catalogue-db
    spec:
      serviceAccountName: sockshop-sa
      containers:
      - name: catalogue-db
        image: weaveworksdemos/catalogue-db:0.3.0
        args: ['sh', '-c', '. /vault/secrets/database-config.txt && docker-entrypoint.sh mysqld']
        ports:
        - name: mysql
          containerPort: 3306
      nodeSelector:
        beta.kubernetes.io/os: linux
EOF
```
#### Deploying SockShop Application
```
kubectl apply -f .
```




## Resources
* [vanilla k8s setup with ansible](https://github.com/sipirsipirmin/k8s-on-ubuntu)
* [vault installation on minikube](https://learn.hashicorp.com/tutorials/vault/kubernetes-minikube)
* [vault k8s-sidecar](https://learn.hashicorp.com/tutorials/vault/kubernetes-sidecar)
* [vault inject-secrets](https://stackoverflow.com/questions/61239479/injecting-vault-secrets-into-kubernetes-pod-environment-variable)
* [mysql image-layers](https://hub.docker.com/layers/mysql/library/mysql/latest/images/sha256-eb791004631abe3bf842b3597043318d19a91e8c86adca55a5f6d4d7b409f2ac?context=explore)



