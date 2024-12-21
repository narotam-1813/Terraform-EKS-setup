variable "vpc_cidr" {
    description = "mention cidr for vpc"
    type = string
}

variable "public_subnets_cidr" {
    description = "CIDR for public subnet"
    type        = list(string)
}

variable "private_subnets_cidr" {
    description = "CIDR for Private subnet"
    type        = list(string)
}

data "aws_availability_zones" "available_zones" {
    state = "available"
}

variable "vpc_name" {
  description = "mention name of the vpc"
}