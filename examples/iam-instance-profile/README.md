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

## Basic Usage

This is an extract from the code in
[main.tf]:

```hcl
module "instance-profile-s3-full-access" {
  source  = "mineiros-io/iam-role/aws"
  version = "~> 0.6.0"

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
cd terraform-aws-iam-role/terraform/examples/require-mfa-credentials
```

### Initializing Terraform

Run `terraform init` to initialize the example. The output should look like:

### Planning the example

Run `terraform plan` to preview the creation of the resources. Attention: We are not creating a plan output file in this case. In a production environment, it would be recommended to create a plan file first that can be applied in an isolated apply run.

### Applying the example

Run `terraform apply -auto-approve` to create the resources. Attention: this will not ask for confirmation and also not use the previously run plan as no plan output file was used.

### Destroying the example

Run `terraform destroy -refresh=false -auto-approve` to destroy all previously created resources again.

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
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver

[releases-github]: https://github.com/mineiros-io/terraform-aws-iam-role/releases
[main.tf]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples/iam-instance-profile/main.tf
[example/]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples/example
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
