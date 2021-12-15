resource "aws_route_table_association" "public-rta" {
  for_each       = aws_subnet.subnet_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "private-rta" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.rt_private.id
}