resource "aws_ecs_cluster" "example-cluster" {
  name = "example-cluster"
}

resource "aws_autoscaling_group" "ecs-example-cluster" {
  name                 = "ecs-example-cluster"
  min_size             = "1"
  max_size             = "5"
  desired_capacity     = "2"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.ecs-example-cluster.name}"
  vpc_zone_identifier  = ["${module.vpc.private_subnets}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ecs-example-cluster-instance"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.env}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "ecs-example-cluster" {
  name_prefix                 = "ecs-example-cluster"
  image_id                    = "${data.aws_ami.aws-ecs-linux.id}"
  instance_type               = "t2.micro"
  security_groups             = ["${aws_security_group.ecs-example-cluster.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-example-cluster.name}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = false
  user_data                   = "${file("user-data/ecs-example-cluster.tpl")}"

  lifecycle {
    create_before_destroy = true
  }
}

#http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
data "aws_ami" "aws-ecs-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_security_group" "ecs-example-cluster" {
  name        = "ecs-example-cluster"
  description = "Allows all traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${module.vpc.public_subnets_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ecs-example-cluster_host_role" {
  name               = "ecs-example_host_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs-example-cluster_instance_role_policy" {
  name   = "ecs-example_instance_role_policy"
  policy = "${file("policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs-example-cluster_host_role.id}"
}

resource "aws_iam_role" "ecs-example-cluster_service_role" {
  name               = "ecs-example_service_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs-example-cluster_service_role_policy" {
  name   = "ecs-example_service_role_policy"
  policy = "${file("policies/ecs-service-role-policy.json")}"
  role   = "${aws_iam_role.ecs-example-cluster_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs-example-cluster" {
  name = "ecs-example-cluster_instance_profile"
  path = "/"
  role = "${aws_iam_role.ecs-example-cluster_host_role.name}"
}
