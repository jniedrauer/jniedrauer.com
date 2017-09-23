# TODO: Remove this once https://github.com/hashicorp/terraform/issues/10722 is fixed
provider "aws" {
    version = "~> 0.1"
    profile = "${var.aws_config["profile"]}"
    region  = "${var.aws_config["region"]}"
}

module "aws" {
    source = "../modules/providers/aws"
    aws_config = "${var.aws_config}"
}

module "keypairs" {
    source = "../modules/services/keypairs"
}

module "webserver-cluster" {
    source = "services/webserver-cluster"
    aws_config = "${var.aws_config}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnets = "${var.public_subnets}"
    private_subnets = "${var.private_subnets}"
    azs = "${var.azs}"
}
