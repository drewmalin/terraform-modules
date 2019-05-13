provider "aws" {
    version = "~> 2.8"
    region  = "us-west-2"
}

variable "namespace" {}
# variable "service_port" {}

locals {
    vpc_cidr_block         = "192.168.0.0/21"
    vpc_availability_zones = ["us-west-2a", "us-west-2b"]

    load_balancer_port = 80

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

# data "aws_ssm_parameter" "db_user" {
#     name = "/${var.namespace}/db_user"
# }

# data "aws_ssm_parameter" "db_pass" {
#     name = "/${var.namespace}/db_pass"
# }

module "cognito" {
    source = "../../modules/cognito"
    namespace = "${var.namespace}"
}

# module "vpc" {
#     source = "../../modules/vpc"

#     namespace          = "${var.namespace}"
#     region             = "${data.aws_region.current.name}"
#     vpc_cidr           = "${local.vpc_cidr_block}"
#     availability_zones = "${local.vpc_availability_zones}"
# }

# module "alb" {
#     source = "../../modules/alb"

#     namespace = "${var.namespace}"
#     vpc_id     = "${module.vpc.vpc_id}"

#     ingress_port     = "${local.load_balancer_port}"
#     target_port      = "${var.service_port}"
#     healthcheck_port = "${var.service_port}"
#     healthcheck_path = "${local.task_healthcheck_path}"

#     subnet_ids         = "${module.vpc.web_subnet_ids}"
#     security_group_ids = ["${aws_security_group.load_balancer.id}"]
# }

# module "fargate" {
#     source = "../../modules/fargate"

#     namespace = "${var.namespace}"
#     region    = "${data.aws_region.current.name}"

#     task_cpu                  = "${local.task_cpu}"
#     task_memory               = "${local.task_mem}"
#     task_instance_count       = "${local.task_instance_count}"

#     container_memory_min = "${local.task_container_mem_min}"
#     container_memory_max = "${local.task_container_mem_max}"

#     env_db_endpoint           = ""
#     env_db_name               = ""
#     env_db_username_ssm_param = ""
#     env_db_password_ssm_param = ""

#     alb_target_group_arn = "${module.alb.target_group_arn}"
#     container_port       = "${var.service_port}"

#     subnet_ids         = "${module.vpc.app_subnet_ids}"
#     security_group_ids = ["${aws_security_group.container.id}"]
# }