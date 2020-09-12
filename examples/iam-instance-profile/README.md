[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Create a Full Access S3 IAM Instance Profile

The code in [main.tf]
creates an IAM Role and an IAM Instance Profile both named 'S3FullAccess' granting
full access to AWS Simple Storage Service (S3).
Because an `instance_profile_name` is set, this role can be assumed
by a `Service = "ec2.amazonaws.com"` principal by default.

## Example Code

This is an extract from the code in
[main.tf]:

```hcl
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
```

## Running the example

### Cloning the repository

```bash
git clone https://github.com/mineiros-io/terraform-aws-iam-role.git
cd terraform-aws-iam-role/terraform/examples/iam-instance-profile
```

### Initializing Terraform

Run `terraform init` to initialize the example. The output should look like:

```bash
Initializing modules...
Downloading git@github.com:mineiros-io/terraform-aws-iam-role.git?ref=v0.3.0 for instance-profile-s3-full-access...
- instance-profile-s3-full-access in .terraform/modules/instance-profile-s3-full-access

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Planning the example

Run `terraform plan` to preview the creation of the resources.
Attention: We are not creating a plan output file in this case. In a production
environment, it would be recommended to create a plan file first that can be
applied in an isolated apply run.

```hcl
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.instance-profile-s3-full-access.data.aws_iam_policy_document.policy[0]: Refreshing state...
module.instance-profile-s3-full-access.data.aws_iam_policy_document.assume_role_policy[0]: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.instance-profile-s3-full-access.aws_iam_instance_profile.instance_profile[0] will be created
  + resource "aws_iam_instance_profile" "instance_profile" {
      + arn         = (known after apply)
      + create_date = (known after apply)
      + id          = (known after apply)
      + name        = "S3FullAcess"
      + path        = "/"
      + role        = "S3FullAccess"
      + roles       = (known after apply)
      + unique_id   = (known after apply)
    }

  # module.instance-profile-s3-full-access.aws_iam_role.role[0] will be created
  + resource "aws_iam_role" "role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ec2.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 3600
      + name                  = "S3FullAccess"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.instance-profile-s3-full-access.aws_iam_role_policy.policy[0] will be created
  + resource "aws_iam_role_policy" "policy" {
      + id     = (known after apply)
      + name   = "S3FullAcess"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "s3:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "S3FullAccess"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = "S3FullAccess"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

### Applying the example

Run `terraform apply -auto-approve` to create the resources.
Attention: this will not ask for confirmation and also not use the previously
run plan as no plan output file was used.

### Destroying the example

Run `terraform destroy -refresh=false -auto-approve` to destroy all
previously created resources again.

## External documentation for the resources created in this example

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_role.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
  - https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html

- AWS Documentation IAM:
  - Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
  - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
  - Instance Profile: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html

<!-- References -->
[homepage]: https://mineiros.io/?ref=terraform-aws-iam-role

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver

[releases-github]: https://github.com/mineiros-io/terraform-aws-iam-role/releases
[main.tf]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples/iam-instance-profile/main.tf
[example/]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples/example
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
