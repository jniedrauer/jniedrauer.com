resource "aws_security_group" "main" {
    name        = "${var.name}"
    description = "${var.description}"
    vpc_id = "${var.vpc}"
}

resource "aws_security_group_rule" "ingress_ssh" {
    type = "ingress"
    from_port = "${var.ports["ssh"]}"
    to_port = "${var.ports["ssh"]}"
    protocol = "tcp"
    cidr_blocks = "${var.ssh_cidrs}"
    security_group_id = "${aws_security_group.main.id}"
    count = "${var.config["ssh"]}"
}

resource "aws_security_group_rule" "ingress_http" {
    type = "ingress"
    from_port = "${var.ports["http"]}"
    to_port = "${var.ports["http"]}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.main.id}"
    count = "${var.config["http"]}"
}

resource "aws_security_group_rule" "ingress_https" {
    type = "ingress"
    from_port = "${var.ports["https"]}"
    to_port = "${var.ports["https"]}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.main.id}"
    count = "${var.config["https"]}"
}

resource "aws_security_group_rule" "egress_all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.main.id}"
}

output "id" {
    value = "${aws_security_group.main.id}"
}
