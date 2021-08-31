variable "image_id" {
  type = string
}

variable "sonarqube_server_instance_type" {
  type = string
}

variable "init_file" {
  description = "The rendered EC2 init file"
}
