terraform {
    required_version = ">= 0.11.7"
}

resource "aws_s3_bucket" "main" {
    bucket = "${var.namespace}-versions"
}

resource "aws_ecr_repository" "main" {
    name = "${var.namespace}"
}

resource "aws_elastic_beanstalk_application" "main" {
    name = "${var.namespace}"
}

resource "aws_elastic_beanstalk_environment" "main" {
    name        = "${var.namespace}-dev"
    application = "${aws_elastic_beanstalk_application.main.name}"
    solution_stack_name = "${var.solution_stack}"
    
    # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html

    ##
    # Networking
    ##
    setting {
        namespace = "aws:ec2:vpc"
        name      = "VPCId"
        value     = "${var.vpc_id}"
    }

    setting {
        namespace = "aws:ec2:vpc"
        name      = "ELBSubnets"
        value     = "${join(", ", var.web_subnet_ids)}"
    }

    setting {
        namespace = "aws:ec2:vpc"
        name      = "Subnets"
        value     = "${join(", ", var.app_subnet_ids)}"
    }

    setting {
        namespace = "aws:elb:loadbalancer"
        name      = "SecurityGroups"
        value     = "${join(", ", var.web_security_group_ids)}"
    }

    setting {
        namespace = "aws:elb:loadbalancer"
        name      = "ManagedSecurityGroup"
        value     = "${join(", ", var.web_security_group_ids)}"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "SecurityGroups"
        value     = "${join(", ", var.app_security_group_ids)}"
    }

    ##
    # Runtime
    ##    
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        value     = "${aws_iam_instance_profile.beanstalk.name}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name      = "StreamLogs"
        value     = "true"
    }

    ##
    # Environment Variables
    ##
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name      = "REGION"
        value     = "${var.env_region}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name      = "PORT"
        value     = "${var.env_port}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name      = "DB_ENDPOINT"
        value     = "${var.env_db_endpoint}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name      = "DB_NAME"
        value     = "${var.env_db_name}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name      = "DB_USERNAME_PARAM"
        value     = "${var.env_db_username_ssm_param}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name      = "DB_PASSWORD_PARAM"
        value     = "${var.env_db_password_ssm_param}"
    }
}
