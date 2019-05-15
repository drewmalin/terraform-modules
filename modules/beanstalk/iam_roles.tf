data "template_file" "ec2_assume_policy_template" {
    template = "${file("${path.module}/templates/ec2_assume_policy.json.tpl")}"
}

resource "aws_iam_role" "beanstalk" {
    name               = "${var.namespace}-ebExecutionRole"
    assume_role_policy = "${data.template_file.ec2_assume_policy_template.rendered}"
}

resource "aws_iam_instance_profile" "beanstalk" {
    name = "${var.namespace}-elb_profile"
    role = "${aws_iam_role.beanstalk.name}"
}

resource "aws_iam_role_policy_attachment" "ecr-read-only" {
    role       = "${aws_iam_role.beanstalk.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ecs" {
    role       = "${aws_iam_role.beanstalk.name}"
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "eb" {
    role       = "${aws_iam_role.beanstalk.name}"
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

##
# Custom policy
##
data "template_file" "ec2_policy_template" {
    template = "${file("${path.module}/templates/ec2_policy.json.tpl")}"
}

resource "aws_iam_role_policy" "beanstalk" {
    name   = "${var.namespace}-eb"
    role   = "${aws_iam_role.beanstalk.id}"
    policy = "${data.template_file.ec2_policy_template.rendered}"
}