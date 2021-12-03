resource "aws_network_interface" "this" {
  for_each = aws_subnet.this
  subnet_id   = each.id
  private_ips = ["${each.cidr_block}"]

  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}"
  }
}