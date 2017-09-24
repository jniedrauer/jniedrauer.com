variable "aws_config" { type = "map" }
variable "vpc_cidr" { type = "string" }
variable "public_subnets" { type = "list" }
variable "private_subnets" { type = "list" }
variable "azs" { type = "map" }
variable "amzn_amis" { type = "map" }
variable "ports" { type = "map" }
variable "ssh_cidrs" { type = "list" }
