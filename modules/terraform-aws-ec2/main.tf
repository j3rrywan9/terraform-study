resource "aws_instance" "sonarqube" {
  ami = var.image_id
  instance_type = var.instance_type

  tags = {
    Name = "SonarQube"
  }

  vpc_security_group_ids = var.vpc_security_group_ids
  key_name = "example"

  user_data = var.init_file

  root_block_device {
    delete_on_termination = true
    encrypted = true
    volume_size = 8
    volume_type = "gp2"

    tags = {
      Terraform    = "true"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
