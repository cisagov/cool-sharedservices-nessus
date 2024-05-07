output "instance_id" {
  description = "The Nessus EC2 instance ID."
  value       = aws_instance.nessus[*].id
}

output "security_group_id" {
  description = "The ID corresponding to the Nessus security group."
  value       = aws_security_group.nessus[*].id
}
