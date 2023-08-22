#AWS instance type
variable "instance_type" {
    description = "ec2 instance type"
    type = string
    default = "t2.micro"
}

#AWS region
variable "aws_region" {
  description = "region in which AWS resource is to be created"
  type        = string
  default     = "us-west-1"
}


variable "my-preferred-ami" {
  type    = string
  default = "ami-0f8e81a3da6e2510a"

}