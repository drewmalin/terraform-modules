output "admin_client_id" {
    value       = "${aws_cognito_user_pool_client.admin.id}"
}

output "admin_client_secret" {
    value       = "${aws_cognito_user_pool_client.admin.client_secret}"
}
