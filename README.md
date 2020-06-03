[<img src="https://raw.githubusercontent.com/mineiros-io/brand/master/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-iam-role)

[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-iam-role/branches/master.svg?style=shields&key=df11a416-f581-4d35-917a-fa3c2de2048e)](https://mineiros.semaphoreci.com/projects/terraform-aws-iam-role)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-iam-role/releases)
[![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-623CE4.svg)](https://github.com/hashicorp/terraform/releases)
[<img src="https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack">](https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg)

# terraform-aws-iam-role

A [Terraform](https://www.terraform.io) 0.12 base module for
[Amazon Web Services (AWS)](https://aws.amazon.com/).

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

Basic usage:

```hcl
module "role-s3-full-access" {
  source = "git@github.com:mineiros-io/terraform-aws-iam-role.git?ref=v0.0.1"

  name = "s3-full-access"

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

See
[variables.tf](https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/variables.tf)
and
[examples/](https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples)
for details and use-cases.

## Module Configuration

- **`module_enabled`**: *(Optional `bool`)*
Specifies whether resources in the module will be created.
Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*
A list of dependencies. Any object can be assigned to this list to define a hidden
external dependency.

### Top-level Arguments

### Main Resource Configuration

- **`name`**: *(Optional `string`, Forces new resource)*
The name of the role. If omitted, Terraform will assign a random, unique name.

- **`name_prefix`**: *(Optional `string`, Forces new resource)*
Creates a unique name beginning with the specified prefix. Conflicts with name.

- **`assume_role_policy`**: **(Required `string(json)`)**
A JSON String representing the policy that grants an entity permission to assume the role.
(only required if `assume_role_principals` is not set)**

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
(only required if `assume_role_policy` is not set)**

```hcl
assume_role_principals = [
  { type        = "Service"
    identifiers = [ "ec2.amazonaws.com" ]
  }
]
```

- **`assume_role_conditions`**: *(Optional `set(condition)`)*
(only evaluated when `assume_role_principals` is used)
A Set of objects representing Conditions in an IAM policy document.

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
The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 - hours.

- **`permissions_boundary`**: *(Optional `string(arn)`)*
The ARN of the policy that is used to set the permissions boundary for the role.

- **`tags`**: *(Optional `map(string)`)*
Key-value map of tags for the IAM role.

### Extended Resource configuration

#### Custom & Managed Policies

- **`policy_arns`**: *(Optional `list(string)`)*
List of IAM custom or managed policies ARNs to attach to the User.

#### Inline Policiy

- **`policy_name`**: *(Optional `string`)*
The name of the role policy. If omitted, Terraform will assign a random, unique name.

- **`policy_name_prefix`**: *(Optional `string`)*
Creates a unique name beginning with the specified prefix. Conflicts with name.

- **`policy_statements`**: *(Optional `list(statement)`)*
List of IAM policy statements to attach to the User as an inline policy.

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

#### Instance Profile

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

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1) Use the `MAJOR` version for incompatible changes.
2) Use the `MINOR` version when adding functionality in a backwards compatible manner.
3) Use the `PATCH` version when introducing backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- In the context of initial development, backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is
  increased. (Initial development)
- In the context of pre-release, backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is
increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service](https://mineiros.io/?ref=terraform-aws-iam-role) company based in Berlin, Germany.
We offer commercial support for all of our projects and encourage you to reach out if you have any questions or need
help. Feel free to send us an email at [hello@mineiros.io](mailto:hello@mineiros.io).

We can also help you with:

- Terraform Modules for all types of infrastructure such as VPC's, Docker clusters,
databases, logging and monitoring, CI, etc.
- Consulting & Training on AWS, Terraform and DevOps.

## Reporting Issues

We use GitHub [Issues](https://github.com/mineiros-io/terraform-aws-iam-role/issues)
to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests](https://github.com/mineiros-io/terraform-aws-iam-role/pulls). If you’d like more information, please
see our [Contribution Guidelines](https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/CONTRIBUTING.md).

## Makefile Targets

This repository comes with a handy
[Makefile](https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/Makefile).  
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros GmbH
