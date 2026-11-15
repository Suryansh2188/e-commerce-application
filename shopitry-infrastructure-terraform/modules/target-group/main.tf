resource "aws_lb_target_group" "gateway_tg" {
  name        = var.name
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = var.health_check_path
    port                = "traffic-port"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = var.name
  }
}

resource "aws_lb_target_group_attachment" "gateway_attachment" {
  target_group_arn = aws_lb_target_group.gateway_tg.arn
  target_id        = var.gateway_instance_id
  port             = 5000
}