terraform {
    required_version = ">= 0.11.7"
}

resource "aws_alb" "main" {
    load_balancer_type = "application"
    subnets            = ["${var.subnet_ids}"]
    security_groups    = ["${var.security_group_ids}"]

    tags {
        Name = "lb-${var.namespace}"
    }
}

resource "aws_alb_target_group" "main" {
    vpc_id = "${var.vpc_id}"

    port        = "${var.target_port}"
    protocol    = "${var.target_protocol}"
    target_type = "ip"

    health_check {
        healthy_threshold = "${var.healthcheck_threshold}"
        interval          = "${var.healthcheck_interval}"
        protocol          = "${var.target_protocol}"
        matcher           = "${var.healthcheck_status_code}"
        timeout           = "${var.healthcheck_timeout}"
        path              = "${var.healthcheck_path}"
    }

    tags {
        Name = "lbtg-${var.namespace}"
    }
}

resource "aws_alb_listener" "main" {
    load_balancer_arn = "${aws_alb.main.id}"

    port     = "${var.ingress_port}"
    protocol = "${var.ingress_protocol}"

    default_action {
        target_group_arn = "${aws_alb_target_group.main.id}"
        type             = "forward"
    }
}


