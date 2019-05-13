terraform {
    required_version = ">= 0.11.7"
}

resource "aws_cognito_user_pool" "default" {
    name = "${var.namespace}"
}

resource "aws_cognito_user_pool_domain" "default" {
    user_pool_id = "${aws_cognito_user_pool.default.id}"
    domain       = "${var.namespace}"
}

resource "aws_cognito_resource_server" "clients" {
    user_pool_id = "${aws_cognito_user_pool.default.id}"

    name       = "clients"
    identifier = "clients"

    scope {
        scope_name        = "get"
        scope_description = "Get all Clients"
    }
}

resource "aws_cognito_user_pool_client" "admin" {
    user_pool_id = "${aws_cognito_user_pool.default.id}"

    name                                 = "admin"
    generate_secret                      = true
    allowed_oauth_flows                  = ["client_credentials"]
    allowed_oauth_scopes                 = ["${aws_cognito_resource_server.clients.scope_identifiers}"]
    allowed_oauth_flows_user_pool_client = true
    refresh_token_validity               = 30
}
