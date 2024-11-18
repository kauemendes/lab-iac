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
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b8c6b923777519db"
  instance_type = "t2.micro"

  key_name = "iac-kaue-alura"
  tags = {
    Name = "ExampleAppServerInstance"
  }
}
