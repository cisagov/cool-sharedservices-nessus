#-------------------------------------------------------------------------------
# Add rules to the Shared Services OpenVPN security group to
# allow Nessus scan traffic.
#-------------------------------------------------------------------------------

# Allow ingress from Nessus security group via any protocol and port
# For: Nessus scans of OpenVPN instances
resource "aws_security_group_rule" "openvpn_ingress_from_nessus_via_any_port" {
  count = var.create_nessus_instance ? 1 : 0

  from_port                = -1
  protocol                 = -1
  security_group_id        = data.terraform_remote_state.openvpn.outputs.security_group_id
  source_security_group_id = aws_security_group.nessus[count.index].id
  to_port                  = -1
  type                     = "ingress"
}

# Allow egress to Nessus security group via Nessus web GUI
# For: DevOps team Nessus web GUI access from within the COOL
resource "aws_security_group_rule" "openvpn_egress_to_nessus_via_port_8834" {
  count = var.create_nessus_instance ? 1 : 0

  from_port                = 8834
  protocol                 = "tcp"
  security_group_id        = data.terraform_remote_state.openvpn.outputs.security_group_id
  source_security_group_id = aws_security_group.nessus[count.index].id
  to_port                  = 8834
  type                     = "egress"
}
