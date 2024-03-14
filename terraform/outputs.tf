output "server_alb_dns" {
  value = aws_alb.server_alb.dns_name
  description = "DNS name of the AWS ALB  for Server service."
}