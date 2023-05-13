resource "aws_instance" "blue" {
  # number of instance in blue
  count                  = var.enable_blue_env ? 2 : 0
  ami                    = "ami-014d05e6b24240371"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  vpc_security_group_ids = [module.web_sg.this_security_group_id]
  user_data = templatefile("${path.module}/init-script.sh", {
    file_content = "Version 1.0 - #${count.index}"
  })


  tags = {
    Name = "blue of ${count.index}"
  }
}

output "public_ip" {
  value = aws_instance.blue[*].public_ip
}