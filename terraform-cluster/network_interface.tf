resource "aws_network_interface" "ni_public_subnet" {
  for_each  = aws_subnet.subnet_public
  subnet_id = each.value.id

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-${index(keys(aws_subnet.subnet_public), each.key) + 1}"
  }
}

resource "aws_network_interface" "ni_private_subnet" {
  subnet_id = aws_subnet.subnet_private.id

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-jump"
  }
}