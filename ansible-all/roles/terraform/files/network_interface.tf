resource "aws_network_interface" "packer-ni-1-test" {
  subnet_id   = aws_subnet.packer-public-subnet-test.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "muhammed_public_subnet_network_interface"
  }
}