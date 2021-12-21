[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-iam-role)

[![Build Status](https://github.com/mineiros-io/terraform-aws-iam-role/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/mineiros-io/terraform-aws-iam-role/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-iam-role/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-iam-role

A [Terraform](https://www.terraform.io) base module for creating and managing
[IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
on [Amazon Web Services (AWS)](https://aws.amazon.com/).

***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
and is compatible with the terraform AWS provider v3 as well as v2.0 and above.***


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
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation IAM](#aws-documentation-iam)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
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
  version = "~> 0.6.0"

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

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be
  overwritten by resource-specific tags.

  Default is `{}`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(any)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be assigned to this list to define a hidden external dependency.

### Top-level Arguments

#### Main Resource Configuration

- [**`name`**](#var-name): *(Optional `string`)*<a name="var-name"></a>

  The name of the role.
Invalid characters will be replaced with dashes.
If omitted, Terraform will assign a random, unique name.
Forces new resource.

- [**`name_prefix`**](#var-name_prefix): *(Optional `string`)*<a name="var-name_prefix"></a>

  If omitted, Terraform will assign a random, unique name.
Invalid characters will be replaced with dashes.
Creates a unique name beginning with the specified prefix.
Conflicts with name.
Forces new resource.

- [**`assume_role_policy`**](#var-assume_role_policy): *(**Required** `string(json)`)*<a name="var-assume_role_policy"></a>

  A JSON String representing the policy that grants an entity permission to assume the role.
*(only required if `assume_role_principals` is not set)*

  Example:

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

- [**`assume_role_principals`**](#var-assume_role_principals): *(**Required** `set(principal)`)*<a name="var-assume_role_principals"></a>

  A Set of objects representing Principals in an IAM policy document.
*(only required if `assume_role_policy` is not set)*

  Example:

  ```hcl
  assume_role_principals = [
    { type        = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  ]
  ```

- [**`assume_role_conditions`**](#var-assume_role_conditions): *(Optional `set(condition)`)*<a name="var-assume_role_conditions"></a>

  A Set of objects representing Conditions in an IAM policy document.
*(only evaluated when `assume_role_principals` is used)*

  Example:

  ```hcl
  assume_role_conditions = [
    { test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = [ "true" ]
    }
  ]
  ```

  The object accepts the following attributes:

  - [**`assume_role_actions`**](#attr-assume_role_actions-assume_role_conditions): *(Optional `list(string)`)*<a name="attr-assume_role_actions-assume_role_conditions"></a>

    A list of strings representing Action in an IAM policy document. 
    *(only evaluated when `assume_role_principals` is used)*

    Default is `["sts:AssumeRole"]`.

    Example:

    ```hcl
    assume_role_actions = [
      "sts:TagSession",
      "sts:AssumeRoleWithSAML"
    ]
    ```

- [**`force_detach_policies`**](#var-force_detach_policies): *(Optional `bool`)*<a name="var-force_detach_policies"></a>

  Specifies to force detaching any policies the role has before destroying it. Defaults to false.

  Default is `false`.

- [**`path`**](#var-path): *(Optional `string`)*<a name="var-path"></a>

  The path to the role. See IAM Identifiers for more information.

  Default is `"/"`.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  The description of the role.

- [**`max_session_duration`**](#var-max_session_duration): *(Optional `number`)*<a name="var-max_session_duration"></a>

  The maximum session duration (in seconds) that you want to set for the specified role.
If you do not specify a value for this setting, the default maximum of one hour is applied.
This setting can have a value from 1 hour to 12 - hours.

  Default is `3600`.

- [**`permissions_boundary`**](#var-permissions_boundary): *(Optional `string`)*<a name="var-permissions_boundary"></a>

  The ARN of the policy that is used to set the permissions boundary for the role.

- [**`tags`**](#var-tags): *(Optional `map(string)`)*<a name="var-tags"></a>

  Key-value map of tags for the IAM role.

  Default is `{}`.

#### Extended Resource configuration

##### Custom & Managed Policies

- [**`policy_arns`**](#var-policy_arns): *(Optional `list(string)`)*<a name="var-policy_arns"></a>

  List of IAM custom or managed policies ARNs to attach to the role.

  Default is `[]`.

##### Inline Policiy

- [**`policy_name`**](#var-policy_name): *(Optional `string`)*<a name="var-policy_name"></a>

  The name of the role policy.
Invalid characters will be replaced with dashes.
If omitted, Terraform will assign a random, unique name.

- [**`policy_name_prefix`**](#var-policy_name_prefix): *(Optional `string`)*<a name="var-policy_name_prefix"></a>

  Creates a unique name beginning with the specified prefix.
Invalid characters will be replaced with dashes.
Conflicts with name.

- [**`create_policy`**](#var-create_policy): *(Optional `bool`)*<a name="var-create_policy"></a>

  Force creation of inline policy, when `policy_statements` can not be computed. Defaults to true if `policy_statements` is a non-empty list and terraform can compute it.

- [**`policy_statements`**](#var-policy_statements): *(Optional `list(statement)`)*<a name="var-policy_statements"></a>

  List of IAM policy statements to attach to the role as an inline policy.

  Example:

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

- [**`create_instance_profile`**](#var-create_instance_profile): *(Optional `bool`)*<a name="var-create_instance_profile"></a>

  Whether to create an instance profile.

- [**`instance_profile_name`**](#var-instance_profile_name): *(Optional `string`)*<a name="var-instance_profile_name"></a>

  Name of the instance profile. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix. Can be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: `_`, `+`, `=`, `,`, `.`, `@`, `-`. Spaces are not allowed.

- [**`instance_profile_name_prefix`**](#var-instance_profile_name_prefix): *(Optional `string`)*<a name="var-instance_profile_name_prefix"></a>

  Creates a unique name beginning with the specified prefix.
Invalid characters will be replaced with dashes.
Conflicts with name.
Forces new resource.

- [**`instance_profile_path`**](#var-instance_profile_path): *(Optional `string`)*<a name="var-instance_profile_path"></a>

  Path in which to create the profile.

  Default is `"/"`.

- [**`instance_profile_tags`**](#var-instance_profile_tags): *(Optional `map(string)`)*<a name="var-instance_profile_tags"></a>

  Key-value map of tags for the IAM instance profile.

  Default is `{}`.

## Module Outputs

The following attributes are exported by the module:

- **`role`**: The `aws_iam_role` object.
- **`policy`**: The `aws_iam_role_policy` object.
- **`policy_attachments`**: An array of `aws_iam_role_policy_attachment` objects.
- **`instance_profile`**: The `aws_iam_instance_profile` object.

## External Documentation

### AWS Documentation IAM

- Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
- Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
- Instance Profile: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile

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

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-role
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-aws-iam-role/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-tf-aws]: https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-aws-iam-role/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-iam-role/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
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
