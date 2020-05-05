# Private DNS A record for Nessus instance
resource "aws_route53_record" "nessus_A" {
  count = var.create_nessus_instance ? 1 : 0

  zone_id = data.terraform_remote_state.networking.outputs.private_zone.id
  name    = "nessus.${data.terraform_remote_state.networking.outputs.private_zone.name}"
  type    = "A"
  ttl     = 60
  records = [aws_instance.nessus[count.index].private_ip]
}
