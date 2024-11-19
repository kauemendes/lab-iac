module "aws_dev" {
  source = "../../infra"
  instance_type = "t2.micro"
  key_ssh = "IaC-DEV"
  aws_region = "us-west-2"
  env_name = "DEV"
  ami_id = "ami-0b8c6b923777519db"
}

output "ip" {
  value = module.aws_dev.public_ip
}