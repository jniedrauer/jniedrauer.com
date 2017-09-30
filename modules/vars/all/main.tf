variable "azs" {
    default = {
        us-east-1 = "us-east-1a,us-east-1b,us-east-1c,us-east-1d,us-east-1e,us-east-1f"
        us-west-2 = "us-west-2a,us-west-2b,us-west-2c"
    }
}
output "azs" { value = "${var.azs}" }

variable "amzn_amis" {
    default = {
        us-east-1 = "ami-a4c7edb2"
    }
}
output "amzn_amis" { value = "${var.amzn_amis}" }

variable "amzn_ecs_amis" {
    default = {
        us-east-1 = "ami-9eb4b1e5"
        us-west-2 = "ami-1d668865"
    }
}
output "amzn_ecs_amis" { value = "${var.amzn_ecs_amis}" }

variable "ssh_cidrs" {
    default = [
        "76.183.216.168/32"
    ]
}
output "ssh_cidrs" { value = "${var.ssh_cidrs}" }

variable "protocol_ports" {
    default = {
        ssh = "22"
        http = "80"
        https = "443"
    }
}
output "protocol_ports" { value = "${var.protocol_ports}" }

variable "zone_id" { default = "ZELCDUNSF35JN" }
output "zone_id" { value = "${var.zone_id}" }
