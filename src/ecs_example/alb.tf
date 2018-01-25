resource "aws_lb" "alb" {
  name            = "ecs-example-cluster-alb"
  internal        = "false"
  subnets         = ["${module.vpc.public_subnets}"]
  security_groups = ["${aws_security_group.ecs-example-alb.id}"]

  tags {
    "Name"        = "${var.env}-alb"
    "Terraform"   = "true"
    "Environment" = "${var.env}"
  }
}

resource "aws_lb_listener" "alb_http" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

resource "aws_security_group" "ecs-example-alb" {
  name        = "ecs-example-alb"
  description = "Allows all HTTP traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
