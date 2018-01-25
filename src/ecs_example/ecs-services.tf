# BEGIN example-api resources
resource "aws_ecs_task_definition" "example-api" {
  family                = "example-api"
  container_definitions = "${file("ecs-tasks/example-api.json")}"
}

resource "aws_lb_listener_rule" "example-api" {
  listener_arn = "${aws_lb_listener.alb_http.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.example-api.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/api/*"]
  }
}

resource "aws_ecs_service" "example-api" {
  name            = "example-api"
  cluster         = "${aws_ecs_cluster.example-cluster.id}"
  task_definition = "${aws_ecs_task_definition.example-api.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs-example-cluster_service_role.arn}"
  depends_on      = ["aws_lb_listener.alb_http"] # Make sure the ALB is fully provisioned first

  load_balancer {
    target_group_arn = "${aws_alb_target_group.example-api.arn}"
    container_name   = "example-api"
    container_port   = 8080
  }

  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_cloudwatch_log_group" "example-api" {
  name              = "example-api"
  retention_in_days = 90
}
# END example-api resources

# BEGIN example-static resources
resource "aws_ecs_task_definition" "example-static" {
  family                = "example-static"
  container_definitions = "${file("ecs-tasks/example-static.json")}"
}

resource "aws_lb_listener_rule" "example-static" {
  listener_arn = "${aws_lb_listener.alb_http.arn}"
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.example-static.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}

resource "aws_ecs_service" "example-static" {
  name            = "example-static"
  cluster         = "${aws_ecs_cluster.example-cluster.id}"
  task_definition = "${aws_ecs_task_definition.example-static.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs-example-cluster_service_role.arn}"
  depends_on      = ["aws_lb_listener.alb_http"] # Make sure the ALB is fully provisioned first

  load_balancer {
    target_group_arn = "${aws_alb_target_group.example-static.arn}"
    container_name   = "example-static"
    container_port   = 80
  }

  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_cloudwatch_log_group" "example-static" {
  name              = "example-static"
  retention_in_days = 90
}

# END example-static resources
