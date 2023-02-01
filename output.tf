output "private_ip" {
  value = zipmap(aws_instance.ubuntu.*.tags.Name, aws_instance.ubuntu.*.private_ip)
}

output "private_dns" {
  value = zipmap(aws_instance.ubuntu.*.tags.Name, aws_instance.ubuntu.*.private_dns)
}

output "alb_id" {
  value = aws_lb.lb.dns_name
}
