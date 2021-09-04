variable "security_groups" {
  description = "Security groups to apply to the ALB"
}

variable "subnet_ids" {
  description = "Subnet IDs"
}

variable "vpc_id" {
  description = "VPC"
}

variable "certificate_arn" {
  description = "ACM certificate to use for the ALB"
}
