resource "aws_internet_gateway" "i_gw" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}"
  }
}
