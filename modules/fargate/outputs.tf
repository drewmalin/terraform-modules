output "ecr_url" {
    description = "The URL to use when pushing new container images."
    value       = "${aws_ecr_repository.main.repository_url}"
}