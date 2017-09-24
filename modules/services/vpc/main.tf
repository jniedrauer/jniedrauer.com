module "static" { source = "../../vars/all" }

resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
}

resource "aws_default_network_acl" "default" {
    default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"
    egress {
        protocol = "-1"
        rule_no = 200
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol   = "-1"
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }
    egress {
        protocol = "-1"
        rule_no = 201
        action = "allow"
        ipv6_cidr_block = "::/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol   = "-1"
        rule_no    = 101
        action     = "allow"
        ipv6_cidr_block = "::/0"
        from_port  = 0
        to_port    = 0
    }
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.public_subnets[count.index]}"
    availability_zone = "${element(split(",", lookup(module.static.azs, var.aws_config["region"])), count.index)}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "public${count.index}"
        Type = "public"
    }
    count = "${length(var.public_subnets)}"
}

output "id" {
    value = "${aws_vpc.main.id}"
}

output "public_subnets" {
    value = "${join(",", aws_subnet.public.*.id)}"
}
