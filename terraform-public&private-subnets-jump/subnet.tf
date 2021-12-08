resource "aws_subnet" "subnet_public" {
  for_each          = toset(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_main.cidr_block, 4, var.az_number[substr(each.key, -1, 0)])
  availability_zone = each.key

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-${index(data.aws_availability_zones.available.names, each.value) + 1}"
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_main.cidr_block, 4, 0)
  availability_zone = local.az

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-private"
  }
}

