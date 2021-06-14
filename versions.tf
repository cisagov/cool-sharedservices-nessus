terraform {
  # We want to hold off on 0.13 or higher until we have tested it.
  required_version = "~> 0.12.0"

  # If you use any other providers you should also pin them to the
  # major version currently being used.  This practice will help us
  # avoid unwelcome surprises.
  required_providers {
    # Version 3.38.0 of the Terraform AWS provider is the first
    # version to support default tags.
    # https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider
    aws       = "~> 3.38"
    cloudinit = "~> 2.0"
  }
}
