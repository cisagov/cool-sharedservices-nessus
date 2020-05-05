# ------------------------------------------------------------------------------
# Create an IAM policy document that only allows specific instance profile
# roles to assume the role this policy is attached to.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "nessus_assume_role_doc" {
  count = var.create_nessus_instance ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.nessus_instance_role[count.index].arn
      ]
    }
  }
}
