resource "aws_launch_template" "sonarqube_server_lt" {
  name_prefix   = "sonarqube-server-lt-"
  image_id      = var.image_id
  instance_type = var.sonarqube_server_instance_type
  key_name      = "sonarqube-ssh-key"

  vpc_security_group_ids = var.vpc_security_group_ids

  iam_instance_profile {
    arn = "arn:aws:iam::950350094460:instance-profile/ecsInstanceRole"
  }

  user_data = "${base64encode(<<EOF
${var.init_file}
EOF
  )}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 30
      volume_type           = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "sonarqube_server"
      Terraform = "true"
    }
  }
}

resource "aws_autoscaling_group" "sonarqube_server_asg" {
  name             = "sonarqube-server-asg"
  max_size         = 1
  min_size         = 0
  desired_capacity = 0
  # TODO: uncomment this
  #protect_from_scale_in = true
  # TODO: figure out health check
  #health_check_type = "EC2"
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.sonarqube_server_lt.id
    version = "$Latest"
  }

  depends_on = [
    aws_launch_template.sonarqube_server_lt
  ]
}
