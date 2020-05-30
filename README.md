[<img src="https://raw.githubusercontent.com/mineiros-io/brand/master/mineiros-vertial-logo-smaller-font.svg" width="200"/>](https://mineiros.io/?ref=terraform-aws-iam-role)

[![Maintained by Mineiros.io](https://img.shields.io/badge/maintained%20by-mineiros.io-f32752.svg)](https://mineiros.io/?ref=terraform-aws-iam-role)
[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-iam-role/branches/master.svg?style=shields&key=04f8b96b-178d-4ff2-b8c6-02228fc80789)](https://mineiros.semaphoreci.com/projects/terraform-aws-iam-role)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-iam-role/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-brightgreen.svg)](https://github.com/hashicorp/terraform/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)

# terraform-aws-iam-role
A [Terraform](https://www.terraform.io) 0.12 base module for
[Amazon Web Services (AWS)](https://aws.amazon.com/).

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [License](#license)

## Module Features
In contrast to the plain `aws_iam_role` resource this module simplifies adding IAM Policies to the role.

- **Standard Module Features**:
  Create an IAM role.

- **Extended Module Features**:
  Create an inline IAM policy, Attach custom or AWS managed policies.

## Getting Started
- WIP
<!--
Most basic usage...

```hcl
module "resource" {
  source  = "mineiros-io/resource/provider"
  version = "~> 0.0.0"
}
```
-->

## Module Argument Reference
See
[variables.tf](https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/variables.tf)
and
[examples/](https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples)
for details and use-cases.

#### Module Configuration
- **`module_enabled`**: *(Optional `bool`)*
Specifies whether resources in the module will be created.
Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*
A list of dependencies. Any object can be assigned to this list to define a hidden
external dependency.

#### Top-level Arguments

##### Main Resource Configuration
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

##### Extended Resource configuration

###### Custom & Managed Policies
- **`policy_arns`**: *(Optional `list(string)`)*
List of IAM custom or managed policies ARNs to attach to the User.

###### Inline Policiy
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

## Module Attributes Reference
The following attributes are exported by the module:
- None (WIP)

## External Documentation
- AWS Documentation IAM:
  - Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
  - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_role.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html

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
Mineiros is a [DevOps as a Service](https://mineiros.io/) company based in Berlin, Germany. We offer commercial support
for all of our projects and encourage you to reach out if you have any questions or need help.
Feel free to send us an email at [hello@mineiros.io](mailto:hello@mineiros.io).

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
