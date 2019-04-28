terraform {
    required_version = ">= 0.11.7"
}

resource "aws_ecs_cluster" "main" {
    name = "${var.namespace}-cluster"
}

resource "aws_ecr_repository" "main" {
    name = "${var.namespace}"
}

resource "aws_cloudwatch_log_group" "main" {}

data "template_file" "task_template" {
    template = "${file("${path.module}/templates/ecs_task.json.tpl")}"

    vars {
        region = "${var.region}"

        name      = "${var.namespace}-task"
        image_url = "${aws_ecr_repository.main.repository_url}"
        
        network_mode = "awsvpc"
        port         = "${var.container_port}"

        cpu        = "${var.container_cpu}"
        memory_min = "${var.container_memory_min}"
        memory_max = "${var.container_memory_max}"

        log_group  = "${aws_cloudwatch_log_group.main.name}"
        log_prefix = "${var.namespace}"

        env_db_endpoint           = "${var.env_db_endpoint}"
        env_db_name               = "${var.env_db_name}"
        env_db_username_ssm_param = "${var.env_db_username_ssm_param}"
        env_db_password_ssm_param = "${var.env_db_password_ssm_param}"
    }
}

resource "aws_ecs_task_definition" "main" {
    requires_compatibilities = ["FARGATE"]
    
    container_definitions = "${data.template_file.task_template.rendered}"
    network_mode          = "awsvpc"
    family                = "${var.namespace}-task"

    cpu    = "${var.task_cpu}"
    memory = "${var.task_memory}"

    execution_role_arn = "${aws_iam_role.service.arn}"
    task_role_arn      = "${aws_iam_role.task.arn}"
}

resource "aws_ecs_service" "main" {
    name = "${var.namespace}-service"

    launch_type     = "FARGATE"
    cluster         = "${aws_ecs_cluster.main.id}"
    task_definition = "${aws_ecs_task_definition.main.arn}"
    desired_count   = "${var.task_instance_count}"

    network_configuration {
        security_groups = ["${var.security_group_ids}"]
        subnets         = ["${var.subnet_ids}"]
    }

    load_balancer {
        target_group_arn = "${var.alb_target_group_arn}"
        container_name   = "${var.namespace}-task"
        container_port   = "${var.container_port}"
    }
}
