# NOTE: Most of the Nessus-related Terraform in this repo can be replaced
# with a module (e.g. "nessus-tf-module") AFTER Terraform modules support
# the use of "count" - see https://github.com/cisagov/cool-system/issues/32
# for details.

# The Nessus AMI
data "aws_ami" "nessus" {
  filter {
    name = "name"
    values = [
      "nessus-hvm-*-x86_64-ebs"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners      = [local.images_account_id]
  most_recent = true
}

# The Nessus EC2 instance
resource "aws_instance" "nessus" {
  count = var.create_nessus_instance ? 1 : 0

  ami                         = data.aws_ami.nessus.id
  associate_public_ip_address = false
  availability_zone           = local.nessus_subnet.availability_zone
  iam_instance_profile        = aws_iam_instance_profile.nessus[count.index].name
  instance_type               = "m5.large"
  subnet_id                   = local.nessus_subnet.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  user_data_base64 = data.cloudinit_config.nessus_cloud_init_tasks[count.index].rendered

  vpc_security_group_ids = [
    aws_security_group.nessus[count.index].id
  ]

  tags = { "Name" = "Nessus" }
  # volume_tags does not yet inherit the default tags from the
  # provider.  See hashicorp/terraform-provider-aws#19188 for more
  # details.
  volume_tags = merge(
    data.aws_default_tags.default.tags,
    {
      "Name" = "Nessus"
    },
  )
}
