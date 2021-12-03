
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
cd terraform-cluster

#Update vars.tf, change ec2_k8s_node_ami_id

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

## Resources
* k8s setup: https://github.com/sipirsipirmin/k8s-on-ubuntu


