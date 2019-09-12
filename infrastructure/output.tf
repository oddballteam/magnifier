output "registry_url" {
  value = "${aws_ecr_repository.magnifier.repository_url}"
}

output "alb_dns_name" {
  value = "${aws_alb.magnifier.dns_name}"
}

output "db_address" {
  value = "${aws_db_instance.default.endpoint}"
}

output "another_dns" {
  value = "${aws_alb.magnifier.dns_name}"
}