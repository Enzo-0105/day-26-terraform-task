resource "aws_lb" "web-lb" {
  name               = var.name
  internal           = var.internal_lb
  load_balancer_type = var.lb_type
  security_groups    = [var.sg]
  subnets            = [var.subnet]
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = var.lb-action
    target_group_arn = aws_lb_target_group.lb-target.arn
  }
}
resource "aws_lb_target_group" "lb-target" {
  name        = var.target_group_name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc
  target_type = var.target_type
}