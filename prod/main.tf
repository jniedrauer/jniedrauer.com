module "static" { source = "../modules/vars/all" }

provider "aws" {
    version = "~> 0.1"
    profile = "jniedrauer.com"
    region  = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "terraform.jniedrauer.com"
        key = "state/prod/prod.tfstate"
        profile = "jniedrauer.com"
        region = "us-east-1"
    }
}

module "keypairs" {
    source = "../modules/services/keypairs"
}

module "webserver-cluster" {
    source = "services/webserver-cluster"
    aws_config = "${var.aws_config}"
}
