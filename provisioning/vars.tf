variable "region" {
  type    = string
  default = "us-west-2"
}
variable "profile" {
  type    = string
  default = "default"
}
variable "ec2_type" {
  type    = string
  default = "t3.large"
}
variable "ec2_volume_size" {
  type    = number
  default = 16
}
variable "ec2_volume_type" {
  type    = string
  default = "gp2"
}
variable "ami_id" {
  type    = string
  default = "ami-0f81e6e71078b75b6"
}

variable "ec2_count" {
  type    = number
  default = 4
  validation {
    condition     = var.ec2_count > 3
    error_message = "The ec2_count value must be minimum 4."
  }
}
variable "PUBLIC_KEY_PATH" {
  type    = string
  default = "../keys/id_rsa.pub"
}
variable "resource_prefix" {
  type    = string
  default = "muhammed"
}
variable "vpc_cidr" {
  type    = string
  default = "172.16.0.0/16"
}

variable "region_number" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = {
    us-east-1      = 1
    us-west-1      = 2
    us-west-2      = 3
    eu-central-1   = 4
    ap-northeast-1 = 5
  }
}

variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
    # and so on, up to n = 14 if that many letters are assigned
  }
}
