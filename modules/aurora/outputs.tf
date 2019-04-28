output "cluster_endpoint" {
    description = "The endpoint of the cluster which can be used to establish a database connection."
    value       = "${aws_rds_cluster.main.endpoint}"
}

output "cluster_db_name" {
    description = "The name of the cluster's database."
    value       = "${aws_rds_cluster.main.database_name}"
}
