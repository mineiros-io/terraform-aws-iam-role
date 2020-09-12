# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE AN IAM INSTANCE PROFILE
# This example shows how to create an IAM Instance Profile that grants full
# access to S3.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# Provider Setup
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

variable "region" {
  type        = string
  description = "The AWS region to run in. Default is 'eu-west-1'"
  default     = "eu-west-1"
}

# ------------------------------------------------------------------------------
# Example Usage: Create a Full S3 Access Instance Profile
# ------------------------------------------------------------------------------

module "instance-profile-s3-full-access" {
  source  = "mineiros-io/iam-role/aws"
  version = "~> 0.3.0"

  # name of the role, policy and instance_profile
  name = "S3FullAccess"

  create_instance_profile = true

  # the policy granting access
  policy_statements = [
    {
      sid = "S3FullAccess"

      actions   = ["s3:*"]
      resources = ["*"]
    }
  ]
}
