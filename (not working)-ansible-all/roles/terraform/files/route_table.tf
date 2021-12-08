resource "aws_route_table" "packer-public_rt-test" {
  vpc_id = aws_vpc.packer-vpc-test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.packer-ig-test.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.packer-ig-test.id
  }

  tags = {
    Name = "muhammed_public_rt"
  }
}