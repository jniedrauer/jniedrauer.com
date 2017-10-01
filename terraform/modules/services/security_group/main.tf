module "static" { source = "../../vars/all" }

resource "aws_security_group" "main" {
    name        = "${var.name}"
    description = "${var.description}"
    vpc_id = "${var.vpc}"
}

resource "aws_security_group_rule" "ingress_ssh" {
    type = "ingress"
    from_port = "${module.static.protocol_ports["ssh"]}"
    to_port = "${module.static.protocol_ports["ssh"]}"
    protocol = "tcp"
    cidr_blocks = "${module.static.ssh_cidrs}"
    security_group_id = "${aws_security_group.main.id}"
    count = "${var.ssh}"
}

resource "aws_security_group_rule" "ingress_tcp" {
    type = "ingress"
    from_port = "${element(var.ports, count.index)}"
    to_port = "${element(var.ports, count.index)}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.main.id}"
    count = "${length(var.ports)}"
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
