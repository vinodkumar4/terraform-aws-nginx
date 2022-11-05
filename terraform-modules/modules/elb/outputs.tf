output "lb_id" {
  value = aws_lb.main.id
}

output "lb_dns" {
  value = aws_lb.main.dns_name
}

output "listener_id" {
  value = aws_lb_listener.listener.id
}

output "target_group_id" {
  value = aws_lb_target_group.main.id
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "aws_lb" {
  description = "The aws_lb resource"
  value       = aws_lb.main
}

output "aws_lb_listener" {
  description = "The aws_lb_listener resource"
  value       = aws_lb_listener.listener
}

output "aws_lb_target_group" {
  description = "The aws_lb_target_group resource"
  value       = aws_lb_target_group.main
}
