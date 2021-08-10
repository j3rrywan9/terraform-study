output "id" {
  value = aws_instance.sonarqube.id
}

output "public_dns" {
  value = aws_instance.sonarqube.public_dns
}

output "public_ip" {
  value = aws_instance.sonarqube.public_ip
}
