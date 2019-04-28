variable "namespace" {
    description = "The namespace of this cluster. This value will be used as part of the 'Name' tag for all components of the cluster."
    type        = "string"
}

variable "db_name" {
    description = "The name of the database."
    type        = "string"
}

variable "db_user" {
    description = "The username of the database."
    type        = "string"
}

variable "db_pass" {
    description = "The password of the database."
    type        = "string"
}

variable "instance_count" {
    description = "The number of cluster instances (must be >= 2, as aurora needs at least 1 writer and 1 reader)."
    default     = 2
}

variable "instance_class" {
    description = "The EC2-style instance class of instances in the cluster."
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

variable "skip_final_snapshot" {
    description = "When true, the cluster will not attempt to take a final database snapshop upon cluster failure or deletion. Disable to speed up stack teardown in non-prod environments."
    default     = false
}
