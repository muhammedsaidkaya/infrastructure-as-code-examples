# Determine all of the available availability zones in the
# current AWS region.
data "aws_availability_zones" "available" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_subnet" "this" {
  for_each          = toset(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 4, var.az_number[substr(each.key, -1, 0)])
  availability_zone = each.key

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-${index(data.aws_availability_zones.available.names, each.value) + 1}"
  }
}

