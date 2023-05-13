output "lb_dns_name" {
  value = aws_lb.app.dns_name
}

output "aws_instance_public_ip" {
  value = aws_instance.blue[*].public_ip
}