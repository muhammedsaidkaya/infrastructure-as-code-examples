resource "aws_vpc" "packer-vpc-test" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true" 
  tags = {
    Name = "muhammed_vpc"
  }
}