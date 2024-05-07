# Private DNS A record for Nessus instance
resource "aws_route53_record" "nessus_A" {
  count = var.create_nessus_instance ? 1 : 0

  name    = "nessus.${data.terraform_remote_state.networking.outputs.private_zone.name}"
  records = [aws_instance.nessus[count.index].private_ip]
  ttl     = 60
  type    = "A"
  zone_id = data.terraform_remote_state.networking.outputs.private_zone.id
}
