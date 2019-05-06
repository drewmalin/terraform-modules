data "aws_caller_identity" "main" {}

data "template_file" "ecs_assume_policy_template" {
    template = "${file("${path.module}/templates/ecs_assume_policy.json.tpl")}"
}

resource "aws_iam_role" "service" {
    name               = "${var.namespace}-ecsTaskExecutionRole"
    assume_role_policy = "${data.template_file.ecs_assume_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "service" {
    role       = "${aws_iam_role.service.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "template_file" "ecs_task_policy_template" {
    template = "${file("${path.module}/templates/ecs_task_policy.json.tpl")}"

    vars {
        region     = "${var.region}"
        account_id = "${data.aws_caller_identity.main.account_id}"
    }
}

resource "aws_iam_role" "task" {
    name = "${var.namespace}-ecs-task"
    assume_role_policy = "${data.template_file.ecs_assume_policy_template.rendered}"
}

resource "aws_iam_role_policy" "task" {
    name = "${var.namespace}-ecsTask"
    role = "${aws_iam_role.task.id}"
    policy = "${data.template_file.ecs_task_policy_template.rendered}"
}