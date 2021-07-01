output "instance_id" {
  value       = aws_instance.nessus[*].id
  description = "The Nessus EC2 instance ID."
}

output "security_group_id" {
  value       = aws_security_group.nessus[*].id
  description = "The ID corresponding to the Nessus security group."
}
