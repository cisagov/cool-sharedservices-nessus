# Create the IAM instance profile for the Nessus EC2 server instance

# The instance profile to be used
resource "aws_iam_instance_profile" "nessus" {
  count = var.create_nessus_instance ? 1 : 0

  name = "nessus_instance_profile"
  role = aws_iam_role.nessus_instance_role[count.index].name
}

# The instance role
resource "aws_iam_role" "nessus_instance_role" {
  count = var.create_nessus_instance ? 1 : 0

  name               = "nessus_instance_role"
  assume_role_policy = data.aws_iam_policy_document.nessus_assume_role_policy_doc.json
}

resource "aws_iam_role_policy" "nessus_assume_delegated_role_policy" {
  count = var.create_nessus_instance ? 1 : 0

  name   = "nessus_assume_delegated_role_policy"
  role   = aws_iam_role.nessus_instance_role[count.index].id
  policy = data.aws_iam_policy_document.nessus_assume_delegated_role_policy_doc[count.index].json
}

# Attach the CloudWatch Agent policy to this role as well
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment_nessus" {
  count = var.create_nessus_instance ? 1 : 0

  role       = aws_iam_role.nessus_instance_role[count.index].id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach the SSM Agent policy to this role as well
resource "aws_iam_role_policy_attachment" "ssm_agent_policy_attachment_nessus" {
  count = var.create_nessus_instance ? 1 : 0

  role       = aws_iam_role.nessus_instance_role[count.index].id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

################################
# Define the role policies below
################################

data "aws_iam_policy_document" "nessus_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

# Allow the Nessus instance to assume the role needed
# to read the Nessus-related data from the SSM Parameter Store
data "aws_iam_policy_document" "nessus_assume_delegated_role_policy_doc" {
  count = var.create_nessus_instance ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      aws_iam_role.nessus_parameterstorereadonly_role[count.index].arn
    ]
    effect = "Allow"
  }
}
