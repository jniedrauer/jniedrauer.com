module "static" { source = "../../../modules/vars/all" }

module "vpc" {
    source = "../../../modules/services/vpc"
    aws_config = "${var.aws_config}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnets = "${var.public_subnets}"
    private_subnets = "${var.private_subnets}"
}

module "security_group" {
    source = "../../../modules/services/security_group"
    name = "webserverSG"
    description = "jniedrauer.com Webserver SG"
    vpc = "${module.vpc.id}"
    ssh = true
    ports = [80, 443]
}

resource "aws_ecr_repository" "ecr" {
    name = "jniedrauer.com"
}

data "template_file" "container-definition" {
    template = "${file("${path.module}/task-definitions/service.json")}"
    vars {
        image = "${aws_ecr_repository.ecr.repository_url}/jniedrauer.com:latest"
    }
}

resource "aws_ecs_task_definition" "service" {
    family                = "service"
    container_definitions = "${data.template_file.container-definition.rendered}"

    # Volumes can go here if needed

    placement_constraints {
        type       = "memberOf"
        expression = "attribute:ecs.availability-zone in [${lookup(module.static.azs, var.aws_config["region"])}]"
    }
}



#module "webserver" {
#    source = "../../../modules/services/ec2"
#    ami = "${lookup(module.static.amzn_ecs_amis, var.aws_config["region"])}"
#    number = 1
#    type = "t2.micro"
#    security_group = "${module.security_group.id}"
#    subnets = "${split(",", module.vpc.public_subnets)}"
#    group = "webserver"
#    packages = ["haproxy", "nc"]
#    files = {
#    }
#}
