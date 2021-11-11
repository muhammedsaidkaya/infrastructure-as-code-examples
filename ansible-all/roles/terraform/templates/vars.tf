# AWS
variable "region" {
  type    = string
  default = "us-west-2"
}

variable "profile" {
  type    = string
  default = "default"
}
variable "ec2_k8s_node_type" {
  type = string
  default = "t3.medium"
}

variable "ec2_k8s_node_ami_id" {
  type = string
  default = "{{ AMI_ID }}"
}

variable "ec2_count" {
  type = number
  default = 3
}

variable "PUBLIC_KEY_PATH" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}