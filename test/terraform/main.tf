provider "aws" {
    version = "~> 2.8"
    region  = "us-west-2"
}

locals {
    namespace = "dmtest"

    vpc_cidr_block         = "192.168.0.0/21"
    vpc_availability_zones = ["us-west-2a", "us-west-2b"]

    load_balancer_port = 80
    task_port          = 8080

    task_instance_count   = 1
    task_healthcheck_path = "/"
    task_cpu              = 256
    task_mem              = 1024
    task_container_mem_min          = 256
    task_container_mem_max          = 1024

    db_instance_count   = 2 // 1 reader, 1 writer
    db_instance_class   = "db.t2.small"
}

data "aws_region" "current" {}

data "aws_ssm_parameter" "db_user" {
    name = "/${local.namespace}/db_user"
}

data "aws_ssm_parameter" "db_pass" {
    name = "/${local.namespace}/db_pass"
}

module "vpc" {
    source = "../../modules/vpc"

    namespace          = "${local.namespace}"
    region             = "${data.aws_region.current.name}"
    vpc_cidr           = "${local.vpc_cidr_block}"
    availability_zones = "${local.vpc_availability_zones}"
}

module "alb" {
    source = "../../modules/alb"

    namespace = "${local.namespace}"
    vpc_id     = "${module.vpc.vpc_id}"

    ingress_port     = "${local.load_balancer_port}"
    target_port      = "${local.task_port}"
    healthcheck_port = "${local.task_port}"
    healthcheck_path = "${local.task_healthcheck_path}"

    subnet_ids         = "${module.vpc.web_subnet_ids}"
    security_group_ids = ["${aws_security_group.load_balancer.id}"]
}

module "fargate" {
    source = "../../modules/fargate"

    namespace = "${local.namespace}"
    region    = "${data.aws_region.current.name}"

    task_cpu                  = "${local.task_cpu}"
    task_memory               = "${local.task_mem}"
    task_instance_count       = "${local.task_instance_count}"

    container_memory_min = "${local.task_container_mem_min}"
    container_memory_max = "${local.task_container_mem_max}"

    env_db_endpoint           = "${module.aurora.cluster_endpoint}"
    env_db_name               = "${module.aurora.cluster_db_name}"
    env_db_username_ssm_param = "${data.aws_ssm_parameter.db_user.name}"
    env_db_password_ssm_param = "${data.aws_ssm_parameter.db_pass.name}"

    alb_target_group_arn = "${module.alb.target_group_arn}"
    container_port       = "${local.task_port}"

    subnet_ids         = "${module.vpc.app_subnet_ids}"
    security_group_ids = ["${aws_security_group.container.id}"]
}

module "aurora" {
    source = "../../modules/aurora"

    namespace = "${local.namespace}"
    db_name   = "${local.namespace}"
    db_user   = "${data.aws_ssm_parameter.db_user.value}"
    db_pass   = "${data.aws_ssm_parameter.db_pass.value}"

    instance_count = "${local.db_instance_count}"
    instance_class = "${local.db_instance_class}"

    subnet_ids         = "${module.vpc.data_subnet_ids}"
    security_group_ids = ["${aws_security_group.database.id}"]

    skip_final_snapshot = true
}