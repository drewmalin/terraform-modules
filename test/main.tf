provider "aws" {
    region = "us-west-2"
}

locals {
    namespace = "dmtest"
}

data "aws_region" "current" {}

data "aws_ssm_parameter" "db_user" {
    name = "/${local.namespace}/db_user"
}

data "aws_ssm_parameter" "db_pass" {
    name = "/${local.namespace}/db_pass"
}

module "vpc" {
    source = "../modules/vpc"

    namespace          = "${local.namespace}"
    region             = "${data.aws_region.current.name}"
    vpc_cidr           = "192.168.0.0/21"
    availability_zones = ["us-west-2a", "us-west-2b"]
}