locals {
  name_prefix = substr(var.name_prefix, 0, 6)
}

# Application load balancer
variable "name_prefix" {
  description = "Name of the load balancer"
  default     = "tf-"
}

variable "loadbalancer_security_group_ids" {
  description = "Security groups to attach to the ALB"
  type        = list(string)
  default     = []
}

variable "loadbalancer_subnets" {
  description = "Public subnets to place ALB in"
  type        = list(string)
}

variable "loadbalancer_internal" {
  description = "Internal or external loadbalancer"
  default     = false
}

variable "loadbalancer_type" {
  description = "Select if application or network loadbalancer"
}


# Listener configuration
variable "listener_port" {
  description = "Port for the listener"
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for the listener"
  default     = "HTTP"
}

variable "listener_certificate" {
  description = "Certificate for the listener. Required for HTTPS"
  default     = ""
}


# Target group
variable "vpc_id" {
  description = "VPC id for the target group"
}

variable "target_group_port" {
  description = "Port for the target group"
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  default     = "HTTP"
}

variable "target_group_type" {
  description = "Target type for target group"
  default     = "ip"
}

variable "target_group_deregistration_delay" {
  description = "The time to wait for in-flight requests to complete while deregistering a target. During this time, the state of the target is draining"
  default     = 300
}

variable "target_group_proxy_protocol_v2" {
  description = "Enable proxy protocol for NLB"
  default     = false
}

# Health check
variable "health_check_port" {
  description = "Health check port"
  default     = 80
}

variable "health_check_protocol" {
  description = "Health check protocol"
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check path"
  default     = "/"
}

variable "health_check_timeout" {
  description = "Health check timeout"
  default     = 6
}

variable "health_check_interval" {
  description = "Health check interval"
  default     = 10
}

variable "health_check_healthy_threshold" {
  description = "Health check healthy threshold"
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Health check unhealthy threshold"
  default     = 2
}

# Shared
variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS."
  default     = ""
  type        = string
}

