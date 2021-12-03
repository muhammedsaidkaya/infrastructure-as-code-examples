resource "aws_vpc" "this" {
  cidr_block = cidrsubnet(var.vpc_cidr, 4, var.region_number[var.region])
  enable_dns_support = "true"
  enable_dns_hostnames = "true" 
  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}"
  }
}