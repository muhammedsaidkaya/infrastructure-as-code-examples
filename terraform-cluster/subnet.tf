resource "aws_subnet" "this" {
  for_each = data.aws_availability_zone.all
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 4, var.az_number[each.value.name_suffix])
  availability_zone = each.key
  
  map_public_ip_on_launch = true
   
  tags = {
    Name = "${var.resource_prefix}-${terraform.workspace}"
  }
}

