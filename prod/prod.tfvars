aws_config = {
    profile = "jniedrauer.com"
    region = "us-east-1"
}

vpc_cidr = "10.11.0.0/16"

public_subnets = [
    "10.11.125.0/27",
    "10.11.125.32/27"
]

private_subnets = [
    "10.11.125.64/27",
    "10.11.125.96/27"
]
