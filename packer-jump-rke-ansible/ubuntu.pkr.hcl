packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "ubuntu-jump-rke-ansible"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210430"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install build-essential aptitude -y",
      "sudo aptitude install python3-pip -y",
      "pip3 install ansible",
      "pip3 install Jinja2 --upgrade",
      "sudo echo 'export PATH=$PATH:/home/ubuntu/.local/bin' >> /home/ubuntu/.bash_profile"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo git clone https://github.com/kloia/rke-ansible.git"
    ]
  }

  provisioner "shell" {
    inline = [
      "curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -",
      "sudo apt-get install apt-transport-https --yes",
      "echo 'deb https://baltocdn.com/helm/stable/debian/ all main' | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list",
      "sudo apt-get update",
      "sudo apt-get install helm",
    ]
  }
}