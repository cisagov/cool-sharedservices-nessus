#-------------------------------------------------------------------------------
# Create the security group and rules for the Nessus instance.
#-------------------------------------------------------------------------------

resource "aws_security_group" "nessus" {
  count = var.create_nessus_instance ? 1 : 0

  vpc_id      = data.aws_vpc.the_vpc.id
  description = "Security group for Nessus server"
  tags = merge(
    var.tags,
    {
      "Name" = "Nessus"
    },
  )
}

# Allow ingress from OpenVPN server subnet via SSH
# For: DevOps team SSH access from within the COOL
resource "aws_security_group_rule" "nessus_ingress_from_vpn_users_via_ssh" {
  count = var.create_nessus_instance ? 1 : 0

  cidr_blocks       = [local.vpn_server_cidr_block]
  protocol          = "tcp"
  security_group_id = aws_security_group.nessus[count.index].id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
}

# Allow ingress from OpenVPN server subnet via Nessus web GUI
# For: DevOps team Nessus web GUI access from within the COOL
resource "aws_security_group_rule" "nessus_ingress_from_vpn_users" {
  count = var.create_nessus_instance ? 1 : 0

  cidr_blocks       = [local.vpn_server_cidr_block]
  protocol          = "tcp"
  security_group_id = aws_security_group.nessus[count.index].id
  type              = "ingress"
  from_port         = 8834
  to_port           = 8834
}

# Allow egress to FreeIPA server security group via any protocol and port
# For: Nessus scans of FreeIPA server instances
resource "aws_security_group_rule" "nessus_egress_to_freeipa_server_sg_via_any_port" {
  count = var.create_nessus_instance ? 1 : 0

  protocol                 = -1
  security_group_id        = aws_security_group.nessus[count.index].id
  type                     = "egress"
  source_security_group_id = data.terraform_remote_state.freeipa.outputs.server_security_group.id
  from_port                = -1
  to_port                  = -1
}

# Allow egress to OpenVPN security group via any protocol and port
# For: Nessus scans of FreeIPA server instances
resource "aws_security_group_rule" "nessus_egress_to_openvpn_sg_via_any_port" {
  count = var.create_nessus_instance ? 1 : 0

  protocol                 = -1
  security_group_id        = aws_security_group.nessus[count.index].id
  type                     = "egress"
  source_security_group_id = data.terraform_remote_state.openvpn.outputs.security_group_id
  from_port                = -1
  to_port                  = -1
}

# Allow egress anywhere via HTTPS
# For: Nessus plugin downloads from tenable.com
resource "aws_security_group_rule" "nessus_egress_to_anywhere_via_https" {
  count = var.create_nessus_instance ? 1 : 0

  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.nessus[count.index].id
  type              = "egress"
  from_port         = 443
  to_port           = 443
}
