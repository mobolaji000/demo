
# Security Group for Server ALB

resource "aws_security_group" "server_alb" {
  name_prefix = "${var.default_tags.project}-ecs-server-alb"
  description = "security group for server application load balancer"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.default_tags.project}-server-alb-sg"
  }
}

resource "aws_security_group_rule" "server_alb_allow_80" {
  security_group_id = aws_security_group.server_alb.id
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  description = "Allow HTTP traffic"
}

resource "aws_security_group_rule" "server_alb_allow_outbound" {
  security_group_id = aws_security_group.server_alb.id
  type = "egress"
  protocol = "-1"
  from_port = 0
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  description = "Allow any outbound traffic"
}

#Security Group for ECS Server Service

resource "aws_security_group" "ecs_server_service" {
  name_prefix = "${var.default_tags.project}-ecs-server-service"
  description = "ECS server service security group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.default_tags.project}-ecs-alb-sg"
  }
}

resource "aws_security_group_rule" "ecs_server_service_allow_9090" {
  security_group_id = aws_security_group.ecs_server_service.id
  type = "ingress"
  protocol = "tcp"
  from_port = 9090
  to_port = 9090
  source_security_group_id = aws_security_group.server_alb.id
  description = "Allow incoming traffic from client ALB into the service container port"
}

resource "aws_security_group_rule" "ecs_server_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_server_service.id
  type = "ingress"
  protocol = -1
  from_port = 0
  to_port = 0
  self = true
  description = "Allow traffic from resources within this security group"
}

resource "aws_security_group_rule" "ecs_server_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_server_service.id
  type = "egress"
  protocol = "-1"
  from_port = 0
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  description = "Allow any outbound traffic"
}