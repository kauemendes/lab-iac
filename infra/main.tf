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

resource "aws_launch_template" "template-server" {
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_ssh
  tags = {
    Name = "TerraformAnsiblePython"
    Env  = "Env-${var.env_name}"
  }
  security_group_names = [var.aws_security_group]
  user_data            = var.is_prod ? filebase64("ansible.sh") : ""
}

resource "aws_key_pair" "chavessh-dev" {
  key_name   = var.key_ssh
  public_key = file("${var.key_ssh}.pub")
}

resource "aws_autoscaling_group" "app_server" {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  name               = var.autoscaling_group_name
  min_size           = var.autoscaling_group_min_size
  max_size           = var.autoscaling_group_max_size
  launch_template {
    id      = aws_launch_template.template-server.id
    version = "$Latest"
  }
  desired_capacity  = 1
  target_group_arns = var.is_prod ? [aws_lb_target_group.target_group[0].arn] : []
}

resource aws_autoscaling_schedule "scale_up" {
  scheduled_action_name  = "scale_up"
  min_size               = 0
  max_size               = 1
  desired_capacity       = var.is_prod ? 1 : 0
  recurrence             = "0 6 * * *"
  start_time             = timeadd(timestamp(), "10m")
  autoscaling_group_name = aws_autoscaling_group.app_server.name
}

resource aws_autoscaling_schedule "scale_down" {
  scheduled_action_name  = "scale_down"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  recurrence             = "0 2 * * *"
  start_time             = timeadd(timestamp(), "11m")
  autoscaling_group_name = aws_autoscaling_group.app_server.name
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.aws_region}b"
}

resource "aws_default_vpc" "default_vpc" {
}

resource "aws_lb" "load_balancer" {
  internal = false
  name     = "app-server"
  subnets  = [aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id]
  count    = var.is_prod ? 1 : 0
}

resource "aws_lb_target_group" "target_group" {
  name     = "target-machines"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default_vpc.id
  count    = var.is_prod ? 1 : 0
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer[0].arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
  count = var.is_prod ? 1 : 0
}

resource "aws_autoscaling_policy" "scale_up_policy_prd" {
  name                   = "scale_up_policy_prd"
  autoscaling_group_name = aws_autoscaling_group.app_server.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    # threshold = 50% de CPU
    target_value = 50.0
  }
  count = var.is_prod ? 1 : 0
}