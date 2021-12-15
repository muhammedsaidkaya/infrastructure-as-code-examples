resource "aws_route_table_association" "this" {
  for_each       = aws_subnet.this
  subnet_id      = each.value.id
  route_table_id = aws_route_table.this.id
}