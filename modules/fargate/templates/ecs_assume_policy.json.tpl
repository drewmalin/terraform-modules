{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": [
                    "ecs-tasks.amazonaws.com"
                ]
            }
        }
    ]
}