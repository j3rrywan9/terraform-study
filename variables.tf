variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}

variable "account_id" {
  description = "The account ID of the member account"
  type        = string
  default     = "950350094460"
}

variable "vpc_id" {
  default = "vpc-b73740ca"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "sonarqubedb"
}

variable "master_db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "master_db_password" {
  description = "Password for the master DB user"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "sonarqube-server-cluster"
}

variable "image_id" {
  description = "AMI image ID"
  type        = string
  # Amazon Linux 2 ECS-optimized AMI in us-east-1
  default = "ami-03db9b2aac6af477d"
}

variable "sonarqube_server_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "docker_compose_version" {
  type    = string
  default = "1.29.2"
}

variable "default_user" {
  type    = string
  default = "ec2-user"
}

variable "container_name" {
  description = "Docker container name"
  type        = string
  default     = "nginx"
}

variable "sonarqube_server_port" {
  description = "The port the SonarQube server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "vpn_cidr_blocks" {
  description = "VPN CIDR blocks"
  type        = list(string)
  default     = ["98.42.201.180/32"]
}

variable "sonarqube_image_tag" {
  description = "SonarQube docker image tag"
  type        = string
  default     = "8.9.2-enterprise"
}

variable "alb_allowed_cidr_blocks" {
  description = "CIDR blocks that are allowed access to ALB"
  type        = list(string)
  default     = ["98.42.201.180/32"]
}

variable "alert_email_address" {
  description = "The email address who will receive alerts"
  type        = string
  default     = "jerry@cafefullstack.com"
}
