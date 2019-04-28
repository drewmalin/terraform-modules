output "vpc_id" {
    description = "The AWS ID of the VPC"
    value       = "${aws_vpc.main.id}"
}

output "web_subnet_ids" {
  description = "The AWS IDs of the web-tier subnets"
  value       = ["${aws_subnet.web.*.id}"]
}

output "app_subnet_ids" {
  description = "The AWS IDs of the app-tier subnets"
  value       = ["${aws_subnet.app.*.id}"]
}

output "data_subnet_ids" {
  description = "The AWS IDs of the data-tier subnets"
  value       = ["${aws_subnet.data.*.id}"]
}

output "web_security_group_id" {
  description = "The AWS IDs of the web-tier security group"
  value       = "${aws_security_group.web.id}"
}

output "app_security_group_id" {
  description = "The AWS IDs of the app-tier security group"
  value       = "${aws_security_group.app.id}"
}

output "data_security_group_id" {
  description = "The AWS IDs of the data-tier security group"
  value       = "${aws_security_group.data.id}"
}