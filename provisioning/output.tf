output "master_public_ip_rke" {
  value = aws_instance.this[*].public_ip
  description = "The public IPs of the nodes"
}

output "master_private_ip_rke" {
  value = aws_instance.this[*].private_ip
  description = "The private IPs of the nodes"
}