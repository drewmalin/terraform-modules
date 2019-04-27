provider "aws" {
    region = "us-west-2"
}

data "aws_region" "current" {}

locals {
    namespace = "dmtest"
}

module "vpc" {
    source = "../modules/vpc"

    namespace          = "${local.namespace}"
    region             = "${data.aws_region.current.name}"
    vpc_cidr           = "192.168.0.0/21"
    availability_zones = ["us-west-2a", "us-west-2b"]
}