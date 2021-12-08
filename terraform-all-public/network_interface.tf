resource "aws_network_interface" "this" {
  for_each  = aws_subnet.this
  subnet_id = each.value.id

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}-${index(keys(aws_subnet.this), each.key) + 1}"
  }
}