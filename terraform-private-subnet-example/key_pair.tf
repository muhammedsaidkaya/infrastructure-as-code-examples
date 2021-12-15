resource "aws_key_pair" "this" {
  key_name   = "${var.resource_prefix}-${terraform.workspace}"
  public_key = file(var.PUBLIC_KEY_PATH)
}