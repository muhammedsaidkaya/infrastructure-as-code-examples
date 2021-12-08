
## How to Setup K8s cluster 

### Packer - AMI Creation
```

cd packer-jump-rke-ansible

packer init
packer validate .
packer build .

```

### Terraform - Provisioning
```
cd terraform-all-public

#Update vars.tf, change ami_id

terraform init
terraform plan
terraform apply

```

### Ansible - Configuration - Vanilla K8s Cluter Setup
```
cd ansible-kubeadm-cluster

#Update host.ini, fill the blanks with master and worker nodes ip addresses

ansible-playbook playbook.yaml -i hosts.ini --private-key ~/.ssh/id_rsa -u ubuntu

```

### RKE Cluster-Rancher-Vault Setup

rke-cluster-rancher-vault-sockshop-setup.md

## Resources
* k8s setup: https://github.com/sipirsipirmin/k8s-on-ubuntu


