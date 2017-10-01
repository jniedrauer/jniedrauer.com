variable "vpc_cidr" { default = "10.11.0.0/16" }

variable "public_subnets" {
    default = [
        "10.11.125.0/27",
        "10.11.125.32/27"
    ]
}

variable "private_subnets" {
    default = [
        "10.11.125.64/27",
        "10.11.125.96/27"
    ]
}

variable "aws_config" { type = "map" }
