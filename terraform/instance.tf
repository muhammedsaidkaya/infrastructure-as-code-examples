resource "aws_instance" "packer-ec2-k8s-node-test" {
  count = 3
  ami           = var.ec2_k8s_node_ami_id
  instance_type = var.ec2_k8s_node_type
  associate_public_ip_address = true

  key_name = aws_key_pair.key_pair.id
  tags = {
    "Desired-State" = "Ignore"
  }
}