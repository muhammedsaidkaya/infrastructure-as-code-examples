resource "aws_instance" "packer-ec2-k8s-node-test" {
  count = var.ec2_count
  ami           = var.ec2_k8s_node_ami_id
  instance_type = var.ec2_k8s_node_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  subnet_id              = aws_subnet.packer-public-subnet-test.id
  key_name = aws_key_pair.key_pair.id
  
  tags = {
    "Desired-State" = "Ignore"
    "Name" = "muhammed-ec2-${count.index}"
  }
  root_block_device {
    volume_size           = 16
    volume_type           = "gp2"
  }
}