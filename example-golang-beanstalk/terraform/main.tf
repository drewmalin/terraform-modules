provider "aws" {
    version = "~> 2.8"
    region  = "us-west-2"
}

variable "namespace" {}
variable "service_port" {}

locals {
    vpc_cidr_block         = "192.168.0.0/21"
    vpc_availability_zones = ["us-west-2a", "us-west-2b"]
    load_balancer_port = 80
    db_instance_count   = 2 // 1 reader, 1 writer
    db_instance_class   = "db.t2.small"
}

data "aws_region" "current" {}

data "aws_ssm_parameter" "db_user" {
    name = "/${var.namespace}/db_user"
}

data "aws_ssm_parameter" "db_pass" {
    name = "/${var.namespace}/db_pass"
}

module "vpc" {
    source = "../../modules/vpc"

    namespace          = "${var.namespace}"
    region             = "${data.aws_region.current.name}"
    vpc_cidr           = "${local.vpc_cidr_block}"
    availability_zones = "${local.vpc_availability_zones}"
}

module "beanstalk" {
    source = "../../modules/beanstalk"

    namespace      = "${var.namespace}"
    solution_stack = "64bit Amazon Linux 2018.03 v2.13.0 running Multi-container Docker 18.06.1-ce (Generic)"
    #solution_stack = "64bit Amazon Linux 2018.03 v2.12.11 running Docker 18.06.1-ce"

    vpc_id                 = "${module.vpc.vpc_id}"
    web_subnet_ids         = "${module.vpc.web_subnet_ids}"
    app_subnet_ids         = "${module.vpc.app_subnet_ids}"
    web_security_group_ids = ["${aws_security_group.load_balancer.id}"]
    app_security_group_ids = ["${aws_security_group.container.id}"]

    env_region                = "${data.aws_region.current.name}"
    env_port                  = "${var.service_port}"
    env_db_endpoint           = "${module.aurora.cluster_endpoint}"
    env_db_name               = "${module.aurora.cluster_db_name}"
    env_db_username_ssm_param = "${data.aws_ssm_parameter.db_user.name}"
    env_db_password_ssm_param = "${data.aws_ssm_parameter.db_pass.name}"
}

module "aurora" {
    source = "../../modules/aurora"

    namespace = "${var.namespace}"
    db_name   = "${replace(var.namespace, "-", "")}"
    db_user   = "${data.aws_ssm_parameter.db_user.value}"
    db_pass   = "${data.aws_ssm_parameter.db_pass.value}"

    instance_count = "${local.db_instance_count}"
    instance_class = "${local.db_instance_class}"

    subnet_ids         = "${module.vpc.data_subnet_ids}"
    security_group_ids = ["${aws_security_group.database.id}"]

    skip_final_snapshot = true
}
