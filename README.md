[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-iam-role

A [Terraform](https://www.terraform.io) 0.12 module for creating and managing
[IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
on [Amazon Web Services (AWS)](https://aws.amazon.com/).

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Module Configuration](#module-configuration)
  - [Top-level Arguments](#top-level-arguments)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource configuration](#extended-resource-configuration)
      - [Custom & Managed Policies](#custom--managed-policies)
      - [Inline Policiy](#inline-policiy)
      - [Instance Profile](#instance-profile)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `aws_iam_role` resource this module simplifies adding IAM Policies to the role.

- **Standard Module Features**:
  Create an IAM role.

- **Extended Module Features**:
  Create an inline IAM policy, Attach custom or AWS managed policies. Create an IAM instance profile.

## Getting Started

Basic usage for granting an AWS Account with Account ID `123456789012` access to assume a role that grants
full access to AWS Simple Storage Service (S3)

```hcl
module "role-s3-full-access" {
  source  = "mineiros-io/iam-role/aws"
  version = "~> 0.1.0"

  name = "S3FullAccess"

  assume_role_principals = [
    {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:root"]
    }
  ]

  policy_statements = [
    {
      sid = "FullS3Access"

      effect    = "Allow"
      actions   = ["s3:*"]
      resources = ["*"]
    }
  ]
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Module Configuration

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*

  A list of dependencies.
  Any object can be assigned to this list to define a hidden external dependency.

### Top-level Arguments

#### Main Resource Configuration

- **`name`**: *(Optional `string`, Forces new resource)*

  The name of the role. If omitted, Terraform will assign a random, unique name.

- **`name_prefix`**: *(Optional `string`, Forces new resource)*

  Creates a unique name beginning with the specified prefix. Conflicts with name.

- **`assume_role_policy`**: **(Required `string(json)`)**

  A JSON String representing the policy that grants an entity permission to assume the role.
  *(only required if `assume_role_principals` is not set)*

  ```hcl
  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
  ```

- **`assume_role_principals`**: **(Required `set(principal)`**

  A Set of objects representing Principals in an IAM policy document.
  *(only required if `assume_role_policy` is not set)*

  ```hcl
  assume_role_principals = [
    { type        = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  ]
  ```

- **`assume_role_conditions`**: *(Optional `set(condition)`)*

  A Set of objects representing Conditions in an IAM policy document.
  *(only evaluated when `assume_role_principals` is used)*

  ```hcl
  assume_role_conditions = [
    { test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = [ "true" ]
    }
  ]
  ```

- **`force_detach_policies`**: *(Optional `bool`)*

  Specifies to force detaching any policies the role has before destroying it. Defaults to false.

- **`path`**: *(Optional `string`)*

  The path to the role. See IAM Identifiers for more information.

- **`description`**: *(Optional `string`)*

  The description of the role.

- **`max_session_duration`**: *(Optional `number`)*

  The maximum session duration (in seconds) that you want to set for the specified role.
  If you do not specify a value for this setting, the default maximum of one hour is applied.
  This setting can have a value from 1 hour to 12 - hours.

- **`permissions_boundary`**: *(Optional `string(arn)`)*

  The ARN of the policy that is used to set the permissions boundary for the role.

- **`tags`**: *(Optional `map(string)`)*

  Key-value map of tags for the IAM role.

#### Extended Resource configuration

##### Custom & Managed Policies

- **`policy_arns`**: *(Optional `list(string)`)*

  List of IAM custom or managed policies ARNs to attach to the role.

##### Inline Policiy

- **`policy_name`**: *(Optional `string`)*

  The name of the role policy. If omitted, Terraform will assign a random, unique name.

- **`policy_name_prefix`**: *(Optional `string`)*

  Creates a unique name beginning with the specified prefix. Conflicts with name.

- **`policy_statements`**: *(Optional `list(statement)`)*

  List of IAM policy statements to attach to the role as an inline policy.

  ```hcl
  policy_statements = [
    {
      sid = "FullS3Access"

      effect = "Allow"

      actions     = [ "s3:*" ]
      not_actions = []

      resources     = [ "*" ]
      not_resources = []

      conditions = [
        { test     = "Bool"
          variable = "aws:MultiFactorAuthPresent"
          values   = [ "true" ]
        }
      ]
    }
  ]
  ```

##### Instance Profile

- **`create_instance_profile`**: *(Optional `bool`)*

  Whether to create an instance profile.
  Default is `true` if `name` or `name_prefix` are set else `false`.

- **`instance_profile_name`**: *(Optional `string`, Forces new resource)*

  The profile's name. If omitted, Terraform will assign a random, unique name.

- **`instance_profile_name_prefix`**: *(Optional `string`, Forces new resource)*

  Creates a unique name beginning with the specified prefix. Conflicts with name.

- **`instance_profile_path`**: *(Optional `string`)*

  Path in which to create the profile. Default is `/`.

## Module Attributes Reference

The following attributes are exported by the module:

- **`role`**: The `aws_iam_role` object.
- **`policy`**: The `aws_iam_role_policy` object.
- **`policy_attachment`**: The `aws_iam_role_policy_attachment` object.
- **`instance_profile`**: The `aws_iam_instance_profile` object.

## External Documentation

- AWS Documentation IAM:
  - Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
  - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
  - Instance Profile: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_role.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
  - https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
We offer commercial support for all of our projects and encourage you to reach out
if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020 [Mineiros GmbH][homepage]

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-role
[hello@mineiros.io]: mailto:hello@mineiros.io

[badge-build]: https://github.com/mineiros-io/terraform-aws-iam-role/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[build-status]: https://github.com/mineiros-io/terraform-aws-iam-role/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-iam-role/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg

[Terraform]: https://www.terraform.io
[AWS]: https://aws.amazon.com/
[Semantic Versioning (SemVer)]: https://semver.org/

[examples/example/main.tf]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples/example/main.tf
[variables.tf]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-iam-role/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-iam-role/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/CONTRIBUTING.md
