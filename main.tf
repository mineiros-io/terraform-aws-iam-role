# ------------------------------------------------------------------------------
# AWS Identity and Access Management (IAM)
# ------------------------------------------------------------------------------
# IAM ROLES
# ------------------------------------------------------------------------------
# An IAM role is an IAM identity that you can create in your account that has
# specific permissions.
#
# AWS Documentation IAM:
#   - Roles:    https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
#   - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
#
# Terraform AWS Provider Documentation:
#   - https://www.terraform.io/docs/providers/aws/r/iam_role.html
#   - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
#   - https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
# ------------------------------------------------------------------------------

resource "aws_iam_role" "role" {
  count = var.module_enabled ? 1 : 0

  name                  = var.name
  name_prefix           = var.name_prefix
  assume_role_policy    = local.assume_role_policy
  force_detach_policies = var.force_detach_policies
  path                  = var.path
  description           = var.description
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
  tags                  = var.tags

  depends_on = [var.module_depends_on]
}

locals {
  create_assume_role_policy = var.module_enabled && var.assume_role_policy == ""
  assume_role_policy        = local.create_assume_role_policy ? data.aws_iam_policy_document.assume_role_policy[0] : var.assume_role_policy
}

data "aws_iam_policy_document" "assume_role_policy" {
  count = local.create_assume_role_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    dynamic "principals" {
      for_each = var.assume_role_principals

      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }

    dynamic "condition" {
      for_each = var.assume_role_conditions

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

locals {
  policy_enabled = var.module_enabled && length(var.policy_statements) > 0
}

data "aws_iam_policy_document" "policy" {
  count = local.policy_enabled ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid           = try(statement.value.sid, null)
      effect        = try(statement.value.effect, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role_policy" "policy" {
  count = local.policy_enabled ? 1 : 0

  name        = var.policy_name
  name_prefix = var.policy_name_prefix

  policy = data.aws_iam_policy_document.policy[0].json
  role   = aws_iam_role.role[0]

  depends_on = [var.module_depends_on]
}

# Attach custom or managed policies
resource "aws_iam_role_policy_attachment" "policy" {
  count = var.module_enabled ? length(var.policy_arns) : 0

  role       = aws_iam_role.role[0]
  policy_arn = var.policy_arns[count.index]

  depends_on = [var.module_depends_on]
}
