provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "asg" {
  source                         = "./modules/terraform-aws-asg"
  image_id                       = var.image_id
  sonarqube_server_instance_type = var.sonarqube_server_instance_type
  init_file                      = data.template_file.init.rendered
}

module "sns" {
  source                    = "./modules/terraform-aws-sns"
  account_id                = var.account_id
  recipient                 = var.alert_email_address
  sonarqube_server_asg_name = module.asg.sonarqube_server_asg_name
}

resource "aws_ecs_capacity_provider" "sonarqube_capacity_provider" {
  name = "sonarqube-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.sonarqube_server_asg_arn

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
