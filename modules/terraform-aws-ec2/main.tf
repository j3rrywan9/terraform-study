resource "aws_instance" "example" {
  ami = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
}
