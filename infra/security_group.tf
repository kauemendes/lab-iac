resource "aws_security_group" "general_access" {
  name        = "general_access"
  description = "Dev Group Allow all inbound traffic"

  ingress{
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  egress{
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    Name = "general_access"
    Env  = "Env-${var.env_name}"
  }
}