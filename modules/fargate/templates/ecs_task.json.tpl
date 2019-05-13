[
    {
        "name": "${name}",
        "image": "${image_url}",
        "networkMode": "${network_mode}",
        "portMappings": [
            {
                "containerPort": ${port},
                "hostPort": ${port}
            }
        ],
        "cpu": ${cpu},
        "memoryReservation": ${memory_min},
        "memory": ${memory_max},
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "${log_prefix}"
            }
        },
        "environment": [
            {
                "name": "PORT",
                "value": "${env_port}"
            },
            {
                "name": "DB_ENDPOINT",
                "value": "${env_db_endpoint}"
            },
            {
                "name": "DB_NAME",
                "value": "${env_db_name}"
            },
            {
                "name": "DB_USERNAME_PARAM",
                "value": "${env_db_username_ssm_param}"
            },
            {
                "name": "DB_PASSWORD_PARAM",
                "value": "${env_db_password_ssm_param}"
            }
        ]
    }
]