resource "aws_instance" "this" {
  count                       = var.ec2_count
  ami                         = var.ami_id
  instance_type               = var.ec2_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.id
  subnet_id                   = aws_subnet.this[keys(aws_subnet.this)[count.index % length(data.aws_availability_zones.available.names)]].id

  tags = {
    "Desired-State" = "Ignore"
    "Name"          = "${var.resource_prefix}-${terraform.workspace}-${count.index}"
  }
  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }
}