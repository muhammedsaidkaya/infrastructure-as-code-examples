
## How to setup your k8s cluster with kubeadm on AWS

```

sudo ansible-playbook ami.yaml

Update ./group_vars/all.yaml, change AMI_ID

sudo ansible-playbook provision.yaml

Update ./host.ini, fill the blanks with master and worker nodes ip addresses

sudo ansible-playbook k8s-cluster.yaml -i host.ini --private-key ~/.ssh/id_rsa -u ubuntu

Done...
```