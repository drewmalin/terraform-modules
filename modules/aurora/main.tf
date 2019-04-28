terraform {
    required_version = ">= 0.11.7"
}

resource "aws_db_subnet_group" "main" {
    subnet_ids = ["${var.subnet_ids}"]

    tags {
        Name = "sng-${var.namespace}"
    }
}

resource "aws_rds_cluster" "main" {
    engine          = "aurora"
    database_name   = "${var.db_name}"
    master_username = "${var.db_user}"
    master_password = "${var.db_pass}"

    db_subnet_group_name   = "${aws_db_subnet_group.main.name}"
    vpc_security_group_ids = ["${var.security_group_ids}"]
    skip_final_snapshot    = "${var.skip_final_snapshot}"
}

resource "aws_rds_cluster_instance" "instance" {
    count = "${var.instance_count}"

    engine               = "aurora"
    instance_class       = "${var.instance_class}"
    cluster_identifier   = "${aws_rds_cluster.main.id}"
    publicly_accessible  = false
    db_subnet_group_name = "${aws_db_subnet_group.main.name}"

    tags {
        Name = "${var.namespace}"
    }
}
