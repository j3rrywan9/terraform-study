variable "instance_security_group_name" {
  description = "The name of the security group for the EC2 Instances"
  type        = string
  default     = "terraform-example-instance"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
}
