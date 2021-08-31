provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_launch_template" "sonarqube_server_lt" {
  name_prefix   = "sonarqube-server-"
  image_id      = var.image_id
  instance_type = var.sonarqube_server_instance_type
  key_name      = "example"

  vpc_security_group_ids = [
    "sg-ef68cbf0",
  ]

  iam_instance_profile {
    arn = "arn:aws:iam::950350094460:instance-profile/ecsInstanceRole"
  }

  user_data = "${base64encode(<<EOF
${data.template_file.init.rendered}
EOF
  )}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 30
      volume_type           = "gp2"
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
  #health_check_type = "EC2"
  vpc_zone_identifier = ["subnet-1fc9d411", "subnet-fc10fbb0"]
  # TODO: figure out ALB integration
  #target_group_arns = var.target_group_arns

  launch_template {
    id      = aws_launch_template.sonarqube_server_lt.id
    version = "$Latest"
  }

  depends_on = [
    aws_launch_template.sonarqube_server_lt
  ]
}

resource "aws_ecs_capacity_provider" "sonarqube_capacity_provider" {
  name = "sonarqube-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.sonarqube_server_asg.arn

    managed_termination_protection = "DISABLED"
    managed_scaling {
      status = "ENABLED"
    }
  }
}

resource "aws_ecs_cluster" "sonarqube_cluster" {
  name = "sonarqube-cluster"

  capacity_providers = [
    aws_ecs_capacity_provider.sonarqube_capacity_provider.name,
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.sonarqube_capacity_provider.name
    base              = 0
    weight            = 1
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "sonarqube_taskdef" {
  family                = "sonarqube-task"
  task_role_arn         = "arn:aws:iam::950350094460:role/ecsTaskExecutionRole"
  network_mode          = "bridge"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": 256,
        "essential": true,
        "image": "nginx",
        "memory": 512,
        "name": "nginx",
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            }
        ],
        "requiresCompatibilities":[
            "EC2"
        ]
    }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "sonarqube-service" {
  name = "sonarqube-service"

  cluster             = aws_ecs_cluster.sonarqube_cluster.id
  task_definition     = aws_ecs_task_definition.sonarqube_taskdef.arn
  scheduling_strategy = "REPLICA"
  desired_count       = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.sonarqube_capacity_provider.name
    base              = 0
    weight            = 1
  }
}
