/**
 * Creates a Network/application loadbalancer.
 */
resource "aws_lb" "main" {
  name_prefix = local.name_prefix

  load_balancer_type = var.loadbalancer_type
  internal           = var.loadbalancer_internal
  subnets            = var.loadbalancer_subnets
  security_groups    = var.loadbalancer_security_group_ids
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.main.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  certificate_arn   = var.listener_certificate
  ssl_policy        = var.ssl_policy

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "main" {
  depends_on = [
  aws_lb.main]

  name_prefix = local.name_prefix

  vpc_id      = var.vpc_id
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_type

  health_check {
    protocol = var.health_check_protocol
    port     = var.health_check_port
    path     = var.health_check_path

    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  proxy_protocol_v2    = var.target_group_proxy_protocol_v2
  deregistration_delay = var.target_group_deregistration_delay

  lifecycle {
    create_before_destroy = true
  }
}

