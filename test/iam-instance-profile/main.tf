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
  source = "../.."

  # name of the role
  name = "S3FullAccess"

  # name of the instance profile
  instance_profile_name = "S3FullAcess"

  # the policy granting access
  policy_statements = [
    {
      sid = "S3FullAccess"

      actions   = ["s3:*"]
      resources = ["*"]
    }
  ]
}
