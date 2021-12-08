resource "aws_internet_gateway" "packer-ig-test" {
  vpc_id = aws_vpc.packer-vpc-test.id
  tags = {
    Name = "muhammed_ig"
  }
}
