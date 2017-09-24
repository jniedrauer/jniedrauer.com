resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.public_subnets[count.index]}"
    availability_zone = "${element(split(",", lookup(var.azs, var.aws_config["region"])), count.index)}"
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
