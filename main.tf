provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "security_groups" {
  source                  = "./modules/terraform-aws-security-groups"
  server_port             = 80
  vpn_cidr_blocks         = var.vpn_cidr_blocks
  alb_allowed_cidr_blocks = var.alb_allowed_cidr_blocks
  vpc_id                  = var.vpc_id
}

module "alb" {
  source          = "./modules/terraform-aws-alb"
  vpc_id          = var.vpc_id
  subnet_ids      = data.aws_subnet_ids.subnet_ids.ids
  certificate_arn = data.aws_acm_certificate.sonarqube.arn
  security_groups = [
    module.security_groups.alb_security_group_id,
  ]

  depends_on = [
    module.security_groups,
  ]
}

module "asg" {
  source                         = "./modules/terraform-aws-asg"
  image_id                       = var.image_id
  sonarqube_server_instance_type = var.sonarqube_server_instance_type
  init_file                      = data.template_file.init.rendered
  vpc_security_group_ids = [
    module.security_groups.asg_security_group_id,
    module.security_groups.ssh_non_prod_vpn_security_group_id,
  ]
  # TODO: remove ASG level ALB integration
  target_group_arns = [
    module.alb.alb_target_group_arn,
  ]
}

module "sns" {
  source                    = "./modules/terraform-aws-sns"
  account_id                = var.account_id
  recipient                 = var.alert_email_address
  sonarqube_server_asg_name = module.asg.sonarqube_server_asg_name
}

resource "aws_ecs_capacity_provider" "sonarqube_server_capacity_provider" {
  name = "sonarqube-server-asg-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.sonarqube_server_asg_arn

    managed_termination_protection = "DISABLED"
    managed_scaling {
      status = "ENABLED"
    }
  }
}

resource "aws_ecs_cluster" "sonarqube_server_cluster" {
  name = var.ecs_cluster_name

  capacity_providers = [
    aws_ecs_capacity_provider.sonarqube_server_capacity_provider.name,
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.sonarqube_server_capacity_provider.name
    base              = 0
    weight            = 1
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "sonarqube_server_taskdef" {
  family        = "sonarqube-server-task"
  task_role_arn = "arn:aws:iam::950350094460:role/ecsTaskExecutionRole"
  # TODO: switch to awsvpc
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

resource "aws_ecs_service" "sonarqube-server-service" {
  name = "sonarqube-service"

  cluster             = aws_ecs_cluster.sonarqube_server_cluster.id
  task_definition     = aws_ecs_task_definition.sonarqube_server_taskdef.arn
  scheduling_strategy = "REPLICA"
  desired_count       = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.sonarqube_server_capacity_provider.name
    base              = 0
    weight            = 1
  }
}
