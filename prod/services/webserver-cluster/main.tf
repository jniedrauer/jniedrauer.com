module "vpc" {
    source = "../../../modules/services/vpc"
    source = "services/webserver-cluster"
    aws_config = "${var.aws_config}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnets = "${var.public_subnets}"
    private_subnets = "${var.private_subnets}"
    azs = "${var.azs}"
}
