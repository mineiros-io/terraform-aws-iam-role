header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-iam-role"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-iam-role/workflows/CI/CD%20Pipeline/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-iam-role/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-iam-role/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-iam-role"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) base module for creating and managing
    [IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
    on [Amazon Web Services (AWS)](https://aws.amazon.com/).

    ***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
    and is compatible with the terraform AWS provider v3 as well as v2.0 and above.***
  END

  section {
    title   = "Module Features"
    content = <<-END
      In contrast to the plain `aws_iam_role` resource this module simplifies adding IAM Policies to the role.

      - **Standard Module Features**:
        Create an IAM role.

      - **Extended Module Features**:
        Create an inline IAM policy, Attach custom or AWS managed policies. Create an IAM instance profile.
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
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
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_tags" {
        type        = map(string)
        default     = {}
        description = <<-END
          A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be
            overwritten by resource-specific tags.
        END
      }

      variable "module_depends_on" {
        type        = list(any)
        description = <<-END
          A list of dependencies.
            Any object can be assigned to this list to define a hidden external dependency.
        END
      }
    }

    section {
      title = "Top-level Arguments"

      section {
        title = "Main Resource Configuration"

        variable "name" {
          type        = string
          description = <<-END
            The name of the role.
            Invalid characters will be replaced with dashes.
            If omitted, Terraform will assign a random, unique name.
            Forces new resource.
          END
        }

        variable "name_prefix" {
          type        = string
          description = <<-END
            If omitted, Terraform will assign a random, unique name.
            Invalid characters will be replaced with dashes.
            Creates a unique name beginning with the specified prefix.
            Conflicts with name.
            Forces new resource.
          END
        }

        variable "assume_role_policy" {
          required       = true
          type           = any
          readme_type    = "string(json)"
          description    = <<-END
            A JSON String representing the policy that grants an entity permission to assume the role.
            *(only required if `assume_role_principals` is not set)*
          END
          readme_example = <<-END
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
          END
        }

        variable "assume_role_principals" {
          required       = true
          type           = any
          readme_type    = "set(principal)"
          description    = <<-END
            A Set of objects representing Principals in an IAM policy document.
            *(only required if `assume_role_policy` is not set)*
          END
          readme_example = <<-END
            assume_role_principals = [
              { type        = "Service"
                identifiers = [ "ec2.amazonaws.com" ]
              }
            ]
          END
        }

        variable "assume_role_conditions" {
          type           = any
          readme_type    = "set(condition)"
          description    = <<-END
            A Set of objects representing Conditions in an IAM policy document.
            *(only evaluated when `assume_role_principals` is used)*
          END
          readme_example = <<-END
            assume_role_conditions = [
              { test     = "Bool"
                variable = "aws:MultiFactorAuthPresent"
                values   = [ "true" ]
              }
            ]
          END

          attribute "assume_role_actions" {
            type           = list(string)
            default        = ["sts:AssumeRole"]
            description    = <<-END
              A list of strings representing Action in an IAM policy document. 
              *(only evaluated when `assume_role_principals` is used)*
            END
            readme_example = <<-END
              assume_role_actions = [
                "sts:TagSession",
                "sts:AssumeRoleWithSAML"
              ]
            END
          }
        }

        variable "force_detach_policies" {
          type        = bool
          default     = false
          description = <<-END
            Specifies to force detaching any policies the role has before destroying it. Defaults to false.
          END
        }

        variable "path" {
          type        = string
          default     = "/"
          description = <<-END
            The path to the role. See IAM Identifiers for more information.
          END
        }

        variable "description" {
          type        = string
          description = <<-END
            The description of the role.
          END
        }

        variable "max_session_duration" {
          type        = number
          default     = 3600
          description = <<-END
            The maximum session duration (in seconds) that you want to set for the specified role.
            If you do not specify a value for this setting, the default maximum of one hour is applied.
            This setting can have a value from 1 hour to 12 - hours.
          END
        }

        variable "permissions_boundary" {
          type        = string
          description = <<-END
            The ARN of the policy that is used to set the permissions boundary for the role.
          END
        }

        variable "tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            Key-value map of tags for the IAM role.
          END
        }
      }

      section {
        title = "Extended Resource configuration"

        section {
          title = "Custom & Managed Policies"

          variable "policy_arns" {
            type        = list(string)
            default     = []
            description = <<-END
              List of IAM custom or managed policies ARNs to attach to the role.
            END
          }
        }

        section {
          title = "Inline Policiy"

          variable "policy_name" {
            type        = string
            description = <<-END
              The name of the role policy.
              Invalid characters will be replaced with dashes.
              If omitted, Terraform will assign a random, unique name.
            END
          }

          variable "policy_name_prefix" {
            type        = string
            description = <<-END
              Creates a unique name beginning with the specified prefix.
              Invalid characters will be replaced with dashes.
              Conflicts with name.
            END
          }

          variable "create_policy" {
            type        = bool
            description = <<-END
              Force creation of inline policy, when `policy_statements` can not be computed. Defaults to true if `policy_statements` is a non-empty list and terraform can compute it.
            END
          }

          variable "policy_statements" {
            type           = any
            readme_type    = "list(statement)"
            description    = <<-END
              List of IAM policy statements to attach to the role as an inline policy.
            END
            readme_example = <<-END
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
            END
          }
        }

        section {
          title = "Instance Profile"

          variable "create_instance_profile" {
            type        = bool
            description = <<-END
              Whether to create an instance profile.
            END
          }

          variable "instance_profile_name" {
            type        = string
            description = <<-END
              Name of the instance profile. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix. Can be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: `_`, `+`, `=`, `,`, `.`, `@`, `-`. Spaces are not allowed.
            END
          }

          variable "instance_profile_name_prefix" {
            type        = string
            description = <<-END
              Creates a unique name beginning with the specified prefix.
              Invalid characters will be replaced with dashes.
              Conflicts with name.
              Forces new resource.
            END
          }

          variable "instance_profile_path" {
            type        = string
            default     = "/"
            description = <<-END
              Path in which to create the profile.
            END
          }

          variable "instance_profile_tags" {
            type        = map(string)
            default     = {}
            description = <<-END
              Key-value map of tags for the IAM instance profile.
            END
          }
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:

      - **`role`**: The `aws_iam_role` object.
      - **`policy`**: The `aws_iam_role_policy` object.
      - **`policy_attachments`**: An array of `aws_iam_role_policy_attachment` objects.
      - **`instance_profile`**: The `aws_iam_instance_profile` object.
    END
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation IAM"
      content = <<-END
        - Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
        - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
        - Instance Profile: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
      We offer commercial support for all of our projects and encourage you to reach out
      if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

      We can also help you with:

      - Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
      - Consulting & training on AWS, Terraform and DevOps
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-iam-role"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/workflows/CI/CD%20Pipeline/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-role.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-tf-aws" {
    value = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "Terraform" {
    value = "https://www.terraform.io"
  }
  ref "AWS" {
    value = "https://aws.amazon.com/"
  }
  ref "Semantic Versioning (SemVer)" {
    value = "https://semver.org/"
  }
  ref "examples/example/main.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples/example/main.tf"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/examples"
  }
  ref "Issues" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/issues"
  }
  ref "LICENSE" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/LICENSE"
  }
  ref "Makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/Makefile"
  }
  ref "Pull Requests" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/pulls"
  }
  ref "Contribution Guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role/blob/master/CONTRIBUTING.md"
  }
}
