# Effectively a no-op target group, just stubbed out to have a default for the ALB config.
resource "aws_alb_target_group" "default" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
}

resource "aws_alb_target_group" "example-static" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
}

resource "aws_alb_target_group" "example-api" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
}
