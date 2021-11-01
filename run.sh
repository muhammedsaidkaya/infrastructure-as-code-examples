#!/bin/bash

cd packer
packer init
packer validate .
packer build .

cd ../terraform
terraform init
terraform plan
terraform apply

cd ../ansible
sudo ansible-playbook -i hosts.ini playbook.yaml 
