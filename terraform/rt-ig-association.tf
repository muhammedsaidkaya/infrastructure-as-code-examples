resource "aws_route_table_association" "packer-rt-ig-association-1-test" {
  subnet_id      = aws_subnet.packer-public-subnet-test.id
  route_table_id = aws_route_table.packer-public_rt-test.id
}

resource "aws_route_table_association" "packer-rt-ig-association-2-test" {
  subnet_id      = aws_subnet.packer-private-subnet-test.id
  route_table_id = aws_route_table.packer-private-rt-test.id
}