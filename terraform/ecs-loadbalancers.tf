resource "aws_lb" "client_alb" {
  name_prefix        = "cl-"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.client_alb.id]
  subnets            = aws_subnet.public.*.id
  idle_timeout       = 60
  ip_address_type    = "dualstack"

  tags = {
    Name = "${var.default_tags.project}-client-alb"
  }
}

resource "aws_lb_target_group" "client_alb_targets" {
  name_prefix          = "cl-"
  port                 = 9090
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 29
    protocol            = "HTTP"

  }

  tags = {
    Name = "${var.default_tags.project}-client-tg"
  }


}

resource "aws_lb_listener" "client_alb_http_80" {
  load_balancer_arn = aws_lb.client_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.client_alb_targets.arn
  }
}

########################################

resource "aws_lb" "server_alb" {
  name_prefix        = "srv-"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.server_alb.id]
  subnets            = aws_subnet.private.*.id
  idle_timeout       = 60
  internal           = true
  tags = {
    Name = "${var.default_tags.project}-server-alb"
  }
}

resource "aws_lb_target_group" "server_alb_targets" {
  name_prefix          = "srv-"
  port                 = 9090
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 29
    protocol            = "HTTP"

  }

  tags = {
    Name = "${var.default_tags.project}-server-tg"
  }


}

resource "aws_lb_listener" "server_alb_http_80" {
  load_balancer_arn = aws_lb.server_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server_alb_targets.arn
  }
}
