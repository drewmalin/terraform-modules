output "target_group_arn" {
    description = "The ARN of the ALB's target group."
    value       = "${aws_alb_target_group.main.arn}"
}

output "dns_name" {
    description = "The ALB's DNS name."
    value       = "${aws_alb.main.dns_name}"
}
