output "registry_url" {
  value = "${aws_ecr_repository.magnifier.repository_url}"
}

output "alb_dns_name" {
  value = "${aws_alb.magnifier.dns_name}"
}
