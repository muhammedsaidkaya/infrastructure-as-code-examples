resource "aws_network_interface" "this" {
  for_each  = aws_subnet.this
  subnet_id = each.value.id
  # private_ips = ["${each.value.cidr_block}"]

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-${index(keys(aws_subnet.this), each.key) + 1}"
  }
}

resource "aws_network_interface" "jump" {
  subnet_id = aws_subnet.jump.id
  # private_ips = ["${each.value.cidr_block}"]

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-jump"
  }
}