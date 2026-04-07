variable "region" {
  description = "Define the region of your resources "
  default = "us-east-1"
  type = string
}

variable "vpc_cidr" {
    description = "vpc cidr range"
    default = "10.0.0.0/16"
    type = string

}

variable "subnet_cidr" {
    description = "subnet cidr range"
    default = "10.0.1.0/24"
    type = string
}

variable "instance_type" {
    description = "define your ec2 instance type"
    default = "t3.micro"
    type = string
  
}

variable "project_name" {
    description = "your project name, provide it yourself"
    type = string
}

variable "environment" {
    description = "Your project env"
    type = string
    default = "dev"
  
}

variable "allowed_ports" {
    description = "allowed ports"
    type = list(number)
    default = [22,80,443]
  
}

variable "extra_tags" {
    description = "extra tags"
    type = map(string)
    default = {}
  
}
