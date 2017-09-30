provider "template" { version = "~> 0.1" }

data "template_file" "cloud-config-base" {
    template = "${file("${path.module}/templates/init.tpl")}"
    vars {
        hostname = "${var.group}${count.index}"
        packages = "${jsonencode(concat(var.default_packages, var.packages))}"
    }
    count = "${var.number}"
}

data "template_file" "cloud-config-users" {
    template = "${file("${path.module}/templates/user.tpl")}"
    vars {
        name = "${lookup(var.users[count.index], "name")}"
        pubkeys = "${jsonencode(split(",", lookup(var.users[count.index], "pubkeys")))}"
    }
    count = "${length(var.users)}"
}

data "template_file" "join-ecs-cluster" {
    template = "${file("${path.module}/templates/ecs-cluster.tpl")}"
    vars {
        cluster = "${var.ecs_cluster}"
    }
}

data "template_cloudinit_config" "config" {
    gzip = false
    base64_encode = false
    part { content = "${data.template_file.cloud-config-base.*.rendered[count.index]}" }
    part { content = "${data.template_file.cloud-config-users.rendered}" }
    part {
        content_type = "text/x-shellscript"
        content = "${data.template_file.join-ecs-cluster.rendered}"
    }
    count = "${var.number}"
}

resource "aws_instance" "main" {
    ami = "${var.ami}"
    count = "${var.number}"
    instance_type = "${var.type}"
    vpc_security_group_ids = ["${var.security_group}"]
    subnet_id = "${var.subnets[count.index]}"
    user_data = "${data.template_cloudinit_config.config.*.rendered[count.index]}"
    iam_instance_profile = "${var.profile}"
    tags {
        Name = "${var.group}${count.index}"
        Group = "${var.group}"
    }
}

#resource "null_resource" "export_rendered_template" {
#  provisioner "local-exec" {
#    command = "cat > test_output.sh <<EOL\n${data.template_cloudinit_config.config.rendered}\nEOL"
#  }
#}
