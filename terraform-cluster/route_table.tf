resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.i_gw.id
  }

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}