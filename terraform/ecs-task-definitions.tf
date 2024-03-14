resource "aws_ecs_task_definition" "server" {
  family                = "${var.default_tags.project}-server"
  requires_compatibilities = ["FARGATE"]
  memory = 512
  cpu = 256
  network_mode = "awsvpc"
  container_definitions = jsonencode([
    {
        name = "server"
        image = "nicholasjackson/fake-service:v0.23.1"
        cpu = 0
        essential = true
        portMappings = [
          {
            containerPort = 9090
            hostPort = 9090
            protocol = "tcp"
          }
        ]

        environment = [
          {
            name = "NAME"
            value = "server"
          },
          {
            name = "MESSAGE"
            value = "Hello from server!"
          }
        ]
    }
  ])
}