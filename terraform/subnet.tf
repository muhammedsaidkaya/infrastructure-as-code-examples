resource "aws_subnet" "packer-public-subnet-test" {
  vpc_id            = aws_vpc.packer-vpc-test.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "muhammed_public_subnet"
  }
}