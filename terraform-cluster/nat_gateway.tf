resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_public[keys(aws_subnet.subnet_public)[0]].id
  depends_on    = [aws_internet_gateway.i_gw]
}