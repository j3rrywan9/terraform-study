variable "image_id" {
  description = "AMI image ID"
}

variable "instance_type" {
  description = "Instance type"
}

variable "vpc_security_group_ids" {
  description = "Security group IDs"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
}
