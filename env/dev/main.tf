module "aws_dev" {
  source                     = "../../infra"
  instance_type              = "t2.micro"
  key_ssh                    = "IaC-DEV"
  aws_region                 = "us-west-2"
  env_name                   = "DEV"
  ami_id                     = "ami-0b8c6b923777519db"
  aws_security_group         = "DEV"
  autoscaling_group_name     = "ASG-DEV"
  autoscaling_group_min_size = 0
  autoscaling_group_max_size = 1
  is_prod                    = false
}