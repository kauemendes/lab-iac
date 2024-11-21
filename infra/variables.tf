variable "aws_region" { 
  type        = string
  default     = "us-west-2"
  description = "AWS Region"
}

variable "key_ssh" {
  type        = string
  description = "SSH Key"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
}

variable "ami_id" {
  type        = string
  description = "Image AMI id"
}

variable "env_name" {
  type        = string
  description = "Env Name"
}

variable "aws_security_group" {
  type        = string
  description = "Security Group"
}

variable "autoscaling_group_name" {
  type        = string
  description = "Autoscaling Group Name"
}
variable "autoscaling_group_min_size" {
  type        = number
  description = "Autoscaling Group Name"
}
variable "autoscaling_group_max_size" {
  type        = number
  description = "Autoscaling Group Name"
}