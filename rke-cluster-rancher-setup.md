<!-- 4 makina kaldır terraform ile. (SIZE ONEMLI 16 GB)
Ssh at jump a
Keyi kopyala - 400 ver. -->

sudo apt-get update
sudo apt install python3-pip --yes
pip3 install ansible
pip3 install Jinja2 --upgrade
export PATH="$(python3 -m site --user-base)/bin":$PATH

git clone https://github.com/kloia/rke2-ansible.git

<!-- Inventory file ı güncelle -->
sh provision.sh

kubectl master da, config master da.


kubectl create namespace cattle-system
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.1

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm install rancher rancher-latest/rancher --namespace cattle-system \
  --set hostname=54-218-47-70.sslip.io	 \
  --set replicas=3
kubectl -n cattle-system get deploy rancher
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'

<!-- URL de şifreyi gir.
HAZIR. -->