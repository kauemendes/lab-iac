module "aws_prd" {
  source = "../../infra"
  instance_type = "t2.micro"
  key_ssh = "IaC-PRD"
  aws_region = "us-west-1"
  env_name = "DEV"
  ami_id = "ami-0819a8650d771b8be"
}

output "ip" {
  value = module.aws_prd.public_ip
}