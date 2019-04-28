variable "namespace" {
    description = "The namespace of this VPC. This value will be used as part of the 'Name' tag for all components of the VPC."
    type        = "string"
}

variable "region" {
    description = "The region into which this VPC will be deployed."
    type        = "string"
}

variable "vpc_cidr" {
    description = "The IPv4 CIDR block for the VPC. Must represent a valid private address range."
    type        = "string"
}

variable "availability_zones" {
    description = "The list of availability zones to use in this VPC."
    type        = "list"
}

