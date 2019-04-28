provider "aws" {
    version = "~> 2.8"
    region  = "us-west-2"
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

module "aurora" {
    source = "../modules/aurora"

    namespace = "${local.namespace}"
    db_name   = "${local.namespace}"
    db_user   = "${data.aws_ssm_parameter.db_user.value}"
    db_pass   = "${data.aws_ssm_parameter.db_pass.value}"

    instance_count = 2 // 1 reader, 1 writer
    instance_class = "db.t2.small"

    subnet_ids         = "${module.vpc.data_subnet_ids}"
    security_group_ids = ["${module.vpc.data_security_group_id}"]

    skip_final_snapshot = true
}