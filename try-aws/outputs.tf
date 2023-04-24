output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instalce_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}