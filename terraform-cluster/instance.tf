resource "aws_instance" "this" {
  count                       = var.ec2_count
  ami                         = var.ami_id
  instance_type               = var.ec2_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg_allow_all.id]
  key_name                    = aws_key_pair.this.id
  subnet_id                   = aws_subnet.subnet_public[keys(aws_subnet.subnet_public)[count.index % length(data.aws_availability_zones.available.names)]].id

  tags = {
    "Desired-State" = "Ignore"
    "Name"          = "${var.resource_prefix}-${terraform.workspace}-${count.index}"
  }
  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }
}

resource "aws_instance" "jump" {
  ami                         = var.ami_id
  instance_type               = var.ec2_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg_allow_ssh.id]
  subnet_id                   = aws_subnet.subnet_private.id
  key_name                    = aws_key_pair.this.id

  tags = {
    "Desired-State" = "Ignore"
    "Name"          = "${var.resource_prefix}-${terraform.workspace}-jump"
  }
  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }
}