output "alert_arn" {
  value = aws_sns_topic.sonarqube_alerts.arn
}
