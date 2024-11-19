terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_ssh
  tags = {
    Name = "TerraformAnsiblePython"
    Env  = "Env-${var.env_name}"
  }
}

resource "aws_key_pair" "chavessh-dev" {
  key_name   = var.key_ssh
  public_key = file("${var.key_ssh}.pub")
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}