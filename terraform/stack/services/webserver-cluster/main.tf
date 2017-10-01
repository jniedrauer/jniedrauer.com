module "static" { source = "../../../modules/vars/all" }

module "vpc" {
    source = "../../../modules/services/vpc"
    aws_config = "${var.aws_config}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnets = "${var.public_subnets}"
    private_subnets = "${var.private_subnets}"
}

resource "aws_ecr_repository" "ecr" {
    name = "jniedrauer"
}

data "template_file" "container-definition" {
    template = "${file("${path.module}/task-definitions/service.json")}"
    vars {
        image = "${aws_ecr_repository.ecr.repository_url}"
    }
}

resource "aws_ecs_task_definition" "service" {
    family = "service"
    container_definitions = "${data.template_file.container-definition.rendered}"

    # Volumes can go here if needed

    placement_constraints {
        type = "memberOf"
        expression = "attribute:ecs.availability-zone in [${lookup(module.static.azs, var.aws_config["region"])}]"
    }
}

resource "aws_ecs_cluster" "website" {
    name = "jniedrauer-com"
}

resource "aws_ecs_service" "website" {
    name = "jniedrauer-com"
    cluster = "${aws_ecs_cluster.website.id}"
    task_definition = "${aws_ecs_task_definition.service.arn}"
    lifecycle {
        ignore_changes = ["task_definition"]
    }
    desired_count = 1
    deployment_minimum_healthy_percent = 0
}

resource "aws_route53_record" "jniedrauer" {
    zone_id = "${module.static.jniedrauer_zone_id}"
    name = "jniedrauer.com"
    type = "A"
    ttl = 3600
    records = ["${module.webserver.public_ip}"]
}

resource "aws_route53_record" "www-jniedrauer" {
    zone_id = "${module.static.jniedrauer_zone_id}"
    name = "www.jniedrauer.com"
    type = "A"

    alias {
        name = "jniedrauer.com"
        zone_id = "${module.static.jniedrauer_zone_id}"
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "josiahniedrauer" {
    zone_id = "${module.static.josiahniedrauer_zone_id}"
    name = "josiahniedrauer.com"
    type = "A"
    ttl = 3600
    records = ["${module.webserver.public_ip}"]
}

resource "aws_route53_record" "www-josiahniedrauer" {
    zone_id = "${module.static.josiahniedrauer_zone_id}"
    name = "www.josiahniedrauer.com"
    type = "A"

    alias {
        name = "josiahniedrauer.com"
        zone_id = "${module.static.josiahniedrauer_zone_id}"
        evaluate_target_health = false
    }
}

resource "aws_iam_role" "ecs-container" {
    name = "ecsContainerRole"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": { 
                "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-ecs-container" {
    role = "${aws_iam_role.ecs-container.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-profile" {
  name = "ecs_profile"
  role = "${aws_iam_role.ecs-container.name}"
}

module "webserver" {
    source = "../../../modules/services/ec2"
    ami = "${lookup(module.static.amzn_ecs_amis, var.aws_config["region"])}"
    number = 1
    type = "t2.micro"
    security_group = "${module.webserver_security_group.id}"
    subnets = "${split(",", module.vpc.public_subnets)}"
    group = "webserver"
    profile = "${aws_iam_instance_profile.ecs-profile.id}"
    packages = ["haproxy", "nc"]
    ecs_cluster = "${aws_ecs_cluster.website.name}"
}

module "webserver_security_group" {
    source = "../../../modules/services/security_group"
    name = "webservers"
    description = "allow web traffic and ssh"
    vpc = "${module.vpc.id}"
    ssh = true
    ports = [80,443]
}
