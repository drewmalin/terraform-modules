variable "namespace" {
    description = "The namespace of this cluster. This value will be used as part of the 'Name' tag for all components of the cluster."
    type        = "string"
}

variable "region" {
    description = "The region into which this ECS cluster will be deployed."
    type        = "string"
}

variable "alb_target_group_arn" {
    description = "The ARN of the ALB target group that should forward network requests to the cluster."
    type        = "string"
}

variable "container_port" {
    description = "The port number of the container to expose."
}

variable "container_cpu" {
    description = "The CPU units to allocate to each container. A value of 0 will prompt ECS to allocate a proportionate amount of the remaining units."
    default = 0
}

variable "container_memory_min" {
    description = "The amount of memory to reserve for each container."
}

variable "container_memory_max" {
    description = "The upper limit of memory to allow each container."
}

variable "task_cpu" {
    description = "The CPU units to allocate to the task (must be a power of 2 between 256 and 4096 inclusive)."
}

variable "task_memory" {
    description = "The amount of memory to allocate to the task."
}

variable "task_instance_count" {
    description = "The number of container instances to start."
    default     = 1
}

variable "env_db_endpoint" {
    description = "The value of the 'DB_ENDPOINT' environment variable which will be available for consumption by all task containers."
    type        = "string"
}

variable "env_db_name" {
    description = "The value of the 'DB_NAME' environment variable which will be available for consumption by all task containers."
    type        = "string"
}

variable "env_db_username_ssm_param" {
    description = "The value of the 'DB_USERNAME_PARAM' environment variable which will be available for consumption by all task containers."
    type        = "string"
}

variable "env_db_password_ssm_param" {
    description = "The value of the 'DB_PASSWORD_PARAM' environment variable which will be available for consumption by all task containers."
    type        = "string"
}

variable "security_group_ids" {
    description = "The list of IDs of the security groups that control access to the cluster instances."
    type        = "list"
}

variable "subnet_ids" {
    description = "The list of IDs of the subnets into which cluster instances will be deployed."
    type        = "list"
}