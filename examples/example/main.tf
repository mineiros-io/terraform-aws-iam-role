# ------------------------------------------------------------------------------
# Example Setup
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

# ------------------------------------------------------------------------------
# Example Usage
# ------------------------------------------------------------------------------
module "instance-profile-s3-full-access" {
  source = "git@github.com:mineiros-io/terraform-aws-iam-role.git?ref=v0.0.1"

  instance_profile_name = "true"

  policy_statements = [
    {
      sid = "FullS3Access"

      effect = "Allow"

      actions     = ["s3:*"]
      not_actions = []

      resources     = ["*"]
      not_resources = []
    }
  ]
}
