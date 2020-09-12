# ------------------------------------------------------------------------------
# Provider Setup
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 3.0"
  region  = var.aws_region
}

variable "aws_region" {
  type        = string
  description = "The AWS region to run in. Default is 'us-east-1'"
  default     = "us-east-1"
}

# ------------------------------------------------------------------------------
# Example Usage: Create a Full S3 Access Instance Profile
# ------------------------------------------------------------------------------

module "instance-profile-s3-full-access" {
  source = "../.."

  name = "S3 Full Access"

  create_instance_profile = true

  policy_statements = [
    {
      sid = "S3FullAccess"

      actions   = ["s3:*"]
      resources = ["*"]
    }
  ]
}
