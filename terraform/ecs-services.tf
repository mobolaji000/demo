resource "aws_ecs_service" "server" {
  name = "${var.default_tags.project}-server"
  cluster = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.server.arn
  desired_count = 1
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.server_alb_targets.arn
    container_name = "server"
    container_port = 9090
  }

  network_configuration {
    subnets = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups = [aws_security_group.ecs_server_service.id]
  }
}