output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "open_security_groups" {
  value = aws_security_group.allow_all_traffic.id
}