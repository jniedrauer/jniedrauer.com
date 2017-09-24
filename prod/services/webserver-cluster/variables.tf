variable "aws_config" { type = "map" }
variable "vpc_cidr" { type = "string" }
variable "public_subnets" { type = "list" }
variable "private_subnets" { type = "list" }
variable "azs" { type = "map" }
variable "ami" { type = "string" }
variable "ports" { type = "map" }
variable "ssh_cidrs" { type = "list" }
variable "security_group_config" {
    type = "map"
    default = {
        ssh = true
        http = true
        https = true
    }
}
