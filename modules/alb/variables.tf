variable "namespace" {
    description = "The namespace of this ALB. This value will be used as part of the 'Name' tag for all components of the ALB."
    type        = "string"
}

variable "vpc_id" {
    description = "The ID of the VPC into which this ALB will be deployed."
    type        = "string"
}

variable "security_group_ids" {
    description = "The list of IDs of the security groups that control access to the ALB."
    type        = "list"
}

variable "subnet_ids" {
    description = "The list of IDs of the subnets into which the ALB will be deployed."
    type        = "list"
}

variable "ingress_port" {
    description = "The port to listen on which the ALB will listen for requests."
    default     = 80
}

variable "ingress_protocol" {
    description = "The protocol to use when listening for requests."
    default     = "HTTP"
}

variable "target_protocol" {
    description = "The protocol to use when forwarding requests."
    default     = "HTTP"
}

variable "target_port" {
    description = "The port to which requests should be forwarded."
}

variable "healthcheck_threshold" {
    description = "The number of consecutive successful checks needed to determine a 'healthy' status."
    default     = 3
}

variable "healthcheck_interval" {
    description = "The number of seconds to wait before each health check."
    default     = 3
}

variable "healthcheck_status_code" {
    description = "The HTTP status code representing a 'healthy' status."
    default     = 200
}

variable "healthcheck_timeout" {
    description = "The number of seconds to wait before a health check is considered to have failed."
    default     = 3
}

variable "healthcheck_path" {
    description = "The path to use when executing a health check."
    default     = "/"
}

variable "healthcheck_port" {
    description = "The port to which health check requests should be made."
}

