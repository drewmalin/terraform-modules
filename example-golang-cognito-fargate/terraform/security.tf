/**
 * Load balancer security group. Allows all inbound and outbound traffic.
 */
#  resource "aws_security_group" "load_balancer" {
#     vpc_id = "${module.vpc.vpc_id}"

#     ingress {
#         protocol    = "tcp"
#         from_port   = "${local.load_balancer_port}"
#         to_port     = "${local.load_balancer_port}"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         protocol    = "-1"
#         from_port   = 0
#         to_port     = 0
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags {
#         Name = "load_balancer-${var.namespace}"
#     }
#  }

/**
 * Container security group. Allows traffic only from instances residing within
 * the load balancer security group.
 */
#   resource "aws_security_group" "container" {
#     vpc_id = "${module.vpc.vpc_id}"

#     ingress {
#         protocol        = "tcp"
#         from_port       = "${var.service_port}"
#         to_port         = "${var.service_port}"
#         security_groups = ["${aws_security_group.load_balancer.id}"]
#     }

#     egress {
#         protocol    = "-1"
#         from_port   = 0
#         to_port     = 0
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags {
#         Name = "container-${var.namespace}"
#     }
#  }
