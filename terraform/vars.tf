# AWS
variable "region" {
  type    = string
  default = "us-west-2"
}

variable "profile" {
  type    = string
  default = "kloiadaas"
}

variable "ec2_bastion_ami_id" {
  type    = string
  default = ""
}

variable "ec2_bastion_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_k8s_node_type" {
  type = string
  default = "t3.medium"
}

variable "ec2_k8s_node_ami_id" {
  type = string
  default = ""
}

variable "PUBLIC_KEY_PATH" {
  type    = string
  default = "/Users/muhammedkaya/.ssh/id_rsa.pub"
}