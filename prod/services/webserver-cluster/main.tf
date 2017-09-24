module "vpc" {
    source = "../../../modules/services/vpc"
    aws_config = "${var.aws_config}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnets = "${var.public_subnets}"
    private_subnets = "${var.private_subnets}"
    azs = "${var.azs}"
}

module "security_group" {
    source = "../../../modules/services/security_group"
    name = "webserverSG"
    description = "jniedrauer.com Webserver SG"
    vpc = "${module.vpc.id}"
    config = "${var.security_group_config}"
    ports = "${var.ports}"
    ssh_cidrs = "${var.ssh_cidrs}"
}

resource "aws_instance" "jniedrauer-com" {
    ami = "${var.ami}"
    count = 1
    instance_type = "t2.nano"
    key_name = "jniedrauer-laptop"
    vpc_security_group_ids = ["${module.security_group.id}"]
    subnet_id = "${element(split(",", module.vpc.public_subnets), count.index)}"
    tags {
        Name = "jniedrauer.com${count.index}"
        Group = "jniedrauer.com"
    }
}
