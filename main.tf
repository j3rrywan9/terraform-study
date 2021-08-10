provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "template_file" "init" {
  template = file("ec2-init.sh.tpl")

  vars = {
    docker_compose_version = var.docker_compose_version
    default_user           = var.default_user
    server_port            = var.server_port
  }
}

module "security_groups" {
  source          = "./modules/terraform-aws-security-groups"
  server_port     = var.server_port
  vpn_cidr_blocks = var.vpn_cidr_blocks
}

module "ec2" {
  source        = "./modules/terraform-aws-ec2"
  image_id      = var.image_id
  instance_type = var.instance_type
  server_port   = var.server_port
  vpc_security_group_ids = [
    module.security_groups.ec2_security_group_id,
    module.security_groups.vpn_security_group_id,
  ]
  init_file = data.template_file.init.rendered
}
