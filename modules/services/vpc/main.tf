module "static" { source = "../../vars/all" }

resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
}

resource "aws_internet_gateway" "main" {
	vpc_id = "${aws_vpc.main.id}"
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

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }
    count = "${length(var.public_subnets)}"
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.*.id[count.index]}"
    route_table_id = "${aws_route_table.public.*.id[count.index]}"
    count = "${length(var.public_subnets)}"
}

resource "aws_network_acl" "default" {
    vpc_id = "${aws_vpc.main.id}"
    subnet_ids = ["${aws_subnet.public.*.id}"]
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

output "id" {
    value = "${aws_vpc.main.id}"
}

output "public_subnets" {
    value = "${join(",", aws_subnet.public.*.id)}"
}
