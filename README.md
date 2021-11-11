
## How to setup your k8s cluster with kubeadm on AWS (Ubuntu-20.04LTS)

### Packer - AMI Creation
```
#!/bin/bash

cd packer

packer init
packer validate .
packer build .

```

### Terraform - Provisioning
```
cd ../terraform

#Update vars.tf, change ec2_k8s_node_ami_id

terraform init
terraform plan
terraform apply

```

### Ansible - Configuration - K8s Cluter Setup
```
cd ../ansible

#Update host.ini, fill the blanks with master and worker nodes ip addresses

ansible-playbook playbook.yaml -i hosts.ini --private-key ~/.ssh/id_rsa -u ubuntu

```

## Resources
* k8s setup: https://github.com/sipirsipirmin/k8s-on-ubuntu


