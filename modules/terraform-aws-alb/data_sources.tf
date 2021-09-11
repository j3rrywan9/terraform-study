data "aws_acm_certificate" "sonarqube" {
  domain   = "sq.cafefullstack.com"
  statuses = ["ISSUED"]
}
