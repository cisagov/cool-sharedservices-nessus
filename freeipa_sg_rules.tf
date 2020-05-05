#-------------------------------------------------------------------------------
# Add rules to the Shared Services FreeIPA server security group to
# allow Nessus scan traffic.
#-------------------------------------------------------------------------------

# Allow ingress from Nessus security group via any protocol and port
# For: Nessus scans of FreeIPA server instances
resource "aws_security_group_rule" "freeipa_server_ingress_from_nessus_via_any_port" {
  count = var.create_nessus_instance ? 1 : 0

  security_group_id        = data.terraform_remote_state.freeipa.outputs.server_security_group.id
  type                     = "ingress"
  protocol                 = -1
  source_security_group_id = aws_security_group.nessus[count.index].id
  from_port                = -1
  to_port                  = -1
}
