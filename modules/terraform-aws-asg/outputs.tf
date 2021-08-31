output "sonarqube_server_asg_arn" {
  value = aws_autoscaling_group.sonarqube_server_asg.arn
}
