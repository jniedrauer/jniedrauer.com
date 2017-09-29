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
    name = "jniedrauer"
}

data "template_file" "container-definition" {
    template = "${file("${path.module}/task-definitions/service.json")}"
    vars {
        image = "${aws_ecr_repository.ecr.repository_url}/jniedrauer.com:latest"
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

resource "aws_iam_role" "ecs" {
    name = "ecsRole"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ecs.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-ecs" {
    role = "${aws_iam_role.ecs.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_elb" "ecs" {
    name = "jniedrauer-website-elb"

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

#  listener {
#    instance_port = 80
#    instance_protocol = "http"
#    lb_port = 443
#    lb_protocol = "https"
#    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
#  }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }

    subnets = ["${split(",", module.vpc.public_subnets)}"]

    tags {
        Name = "jniedrauer.com"
    }
}

resource "aws_ecs_service" "website" {
    name = "jniedrauer-com"
    cluster = "${aws_ecs_cluster.website.id}"
    task_definition = "${aws_ecs_task_definition.service.arn}"
    desired_count = 1
    iam_role = "${aws_iam_role.ecs.id}"
    depends_on = ["aws_iam_role_policy_attachment.attach-ecs"]

    load_balancer {
        elb_name = "${aws_elb.ecs.name}"
        container_name = "app"
        container_port = 80
    }

    placement_constraints {
        type = "memberOf"
        expression = "attribute:ecs.availability-zone in [${lookup(module.static.azs, var.aws_config["region"])}]"
    }
}

resource "aws_route53_record" "website" {
    zone_id = "${module.static.zone_id}"
    name = "jniedrauer.com"
    type = "A"

    alias {
        name = "${aws_elb.ecs.dns_name}"
        zone_id = "${aws_elb.ecs.zone_id}"
        evaluate_target_health = false
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
