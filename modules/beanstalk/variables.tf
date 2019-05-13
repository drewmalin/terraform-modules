variable "namespace" {
  
}

variable "solution_stack" {
  
}

variable "vpc_id" {
  
}

variable "web_subnet_ids" {
    type = "list"
}

variable "app_subnet_ids" {
    type = "list"
}

variable "web_security_group_ids" {
    type = "list"
}

variable "app_security_group_ids" {
    type = "list"
}

variable "env_region" {
    
}

variable "env_port" {
    description = "The value of the 'PORT' environment variable which will be available for consumption by all task containers."
    type        = "string"
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