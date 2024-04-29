
# Security Group for Client ALB

resource "aws_security_group" "client_alb" {
  name_prefix = "${var.default_tags.project}-ecs-client-alb"
  description = "security group for client application load balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.default_tags.project}-client-alb-sg"
  }
}

resource "aws_security_group_rule" "client_alb_allow_80" {
  security_group_id = aws_security_group.client_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP traffic"
}

resource "aws_security_group_rule" "client_alb_allow_outbound" {
  security_group_id = aws_security_group.client_alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic"
}

#Security Group for ECS Client Service

resource "aws_security_group" "ecs_client_service" {
  name_prefix = "${var.default_tags.project}-ecs-client-service"
  description = "ECS client service security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.default_tags.project}-client-service-sg"
  }
}

resource "aws_security_group_rule" "ecs_client_service_allow_9090" {
  security_group_id        = aws_security_group.ecs_client_service.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.client_alb.id
  description              = "Allow incoming traffic from client ALB into the service container port"
}

resource "aws_security_group_rule" "ecs_client_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_client_service.id
  type              = "ingress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  self              = true
  description       = "Allow traffic from resources within this security group"
}

resource "aws_security_group_rule" "ecs_client_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_client_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic"
}

############################################################

# Security Group for Server ALB

resource "aws_security_group" "server_alb" {
  name_prefix = "${var.default_tags.project}-ecs-server-alb"
  description = "security group for server application load balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.default_tags.project}-server-alb-sg"
  }
}

resource "aws_security_group_rule" "server_alb_allow_80" {
  security_group_id        = aws_security_group.server_alb.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.ecs_client_service.id
  description              = "Allow HTTP traffic"
}

resource "aws_security_group_rule" "server_alb_allow_outbound" {
  security_group_id = aws_security_group.server_alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic"
}

#Security Group for ECS Server Service

resource "aws_security_group" "ecs_server_service" {
  name_prefix = "${var.default_tags.project}-ecs-server-service"
  description = "ECS server service security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.default_tags.project}-server-service-sg"
  }
}

resource "aws_security_group_rule" "ecs_server_service_allow_9090" {
  security_group_id        = aws_security_group.ecs_server_service.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.server_alb.id
  description              = "Allow incoming traffic from server ALB into the service container port"
}

resource "aws_security_group_rule" "ecs_server_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_server_service.id
  type              = "ingress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  self              = true
  description       = "Allow traffic from resources within this security group"
}

resource "aws_security_group_rule" "ecs_server_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_server_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic"
}


#############################################################

#Security Group for Database Service

resource "aws_security_group" "database" {
  name_prefix = "${var.default_tags.project}-database"
  description = "Database security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.default_tags.project}-database-sg"
  }
}

resource "aws_security_group_rule" "database_allow_server_27017" {
  security_group_id        = aws_security_group.ecs_server_service.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 27017
  to_port                  = 27017
  source_security_group_id = aws_security_group.ecs_server_service.id
  description              = "Allow incoming traffic from server into the database port"
}

resource "aws_security_group_rule" "database_allow_outbound" {
  security_group_id = aws_security_group.database.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic"
}

