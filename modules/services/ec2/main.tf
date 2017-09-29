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

data "template_file" "cloud-config-files" {
    template = "${file("${path.module}/templates/file.tpl")}"
    vars {
        content = "${lookup(var.files[count.index], "content")}"
        owner = "${lookup(var.files[count.index], "owner")}"
        group = "${lookup(var.files[count.index], "group")}"
        mode = "${lookup(var.files[count.index], "mode")}"
        path = "${lookup(var.files[count.index], "path")}"
    }
    count = "${length(var.files)}"
}

data "template_cloudinit_config" "config" {
    gzip = false
    base64_encode = false
    part { content = "${data.template_file.cloud-config-base.*.rendered[count.index]}" }
    part { content = "${data.template_file.cloud-config-users.rendered}" }
    part { content = "${data.template_file.cloud-config-files.rendered}" }
    count = "${var.number}"
}

#resource "aws_instance" "main" {
#    ami = "${var.ami}"
#    count = "${var.number}"
#    instance_type = "${var.type}"
#    vpc_security_group_ids = ["${var.security_group}"]
#    subnet_id = "${var.subnets[count.index]}"
#    user_data = "${data.template_cloudinit_config.config.*.rendered[count.index]}"
#    tags {
#        Name = "${var.group}${count.index}"
#        Group = "${var.group}"
#    }
#}

#resource "null_resource" "export_rendered_template" {
#  provisioner "local-exec" {
#    command = "cat > test_output.sh <<EOL\n${data.template_cloudinit_config.config.rendered}\nEOL"
#  }
#}
