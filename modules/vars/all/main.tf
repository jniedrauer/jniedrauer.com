output "azs" {
    value = {
        us-east-1 = "us-east-1a,us-east-1b,us-east-1c,us-east-1d,us-east-1e,us-east-1f"
        us-west-2 = "us-west-2a,us-west-2b,us-west-2c"
    }
}

output "amzn_amis" {
    value = {
        us-east-1 = "ami-a4c7edb2"
    }
}

output "amzn_ecs_amis" {
    value = {
        us-east-1 = "ami-9eb4b1e5"
        us-west-2 = "ami-1d668865"
    }
}

output "ssh_cidrs" {
    value = [
        "76.183.216.168/32"
    ]
}

output "protocol_ports" {
    value = {
        ssh = "22"
        http = "80"
        https = "443"
    }
}

output "jniedrauer_zone_id" { value = "ZELCDUNSF35JN" }

output "josiahniedrauer_zone_id" { value = "Z2HTWVNDFNAJVB" }
