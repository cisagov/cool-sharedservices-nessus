# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------
variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy into (e.g. us-east-1)."
  type        = string
}

variable "create_nessus_instance" {
  default     = false
  description = "A boolean that determines whether or not to create the Nessus instance."
  type        = bool
}

variable "nessus_activation_code" {
  default     = ""
  description = "The Nessus activation code (e.g. \"AAAA-BBBB-CCCC-DDDD\")."
  type        = string
}

variable "ssm_key_nessus_admin_password" {
  default     = "/nessus/sharedservices/admin_password"
  description = "The AWS SSM Parameter Store parameter that contains the password of the Nessus admin user (e.g. \"/nessus/sharedservices/admin_password\")."
  type        = string
}

variable "ssm_key_nessus_admin_username" {
  default     = "/nessus/sharedservices/admin_username"
  description = "The AWS SSM Parameter Store parameter that contains the username of the Nessus admin user (e.g. \"/nessus/sharedservices/admin_username\")."
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created."
  type        = map(string)
}
