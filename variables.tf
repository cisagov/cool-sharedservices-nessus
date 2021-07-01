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
  type        = string
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-east-1"
}

variable "create_nessus_instance" {
  type        = bool
  description = "A boolean that determines whether or not to create the Nessus instance."
  default     = false
}

variable "nessus_activation_code" {
  type        = string
  description = "The Nessus activation code (e.g. \"AAAA-BBBB-CCCC-DDDD\")."
  default     = ""
}

variable "ssm_key_nessus_admin_password" {
  type        = string
  description = "The AWS SSM Parameter Store parameter that contains the password of the Nessus admin user (e.g. \"/nessus/sharedservices/admin_password\")."
  default     = "/nessus/sharedservices/admin_password"
}

variable "ssm_key_nessus_admin_username" {
  type        = string
  description = "The AWS SSM Parameter Store parameter that contains the username of the Nessus admin user (e.g. \"/nessus/sharedservices/admin_username\")."
  default     = "/nessus/sharedservices/admin_username"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}
