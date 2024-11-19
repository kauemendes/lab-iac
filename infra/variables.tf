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