# ------------------------------------------------------------------------------
# AWS Identity and Access Management (IAM)
# ------------------------------------------------------------------------------
# IAM ROLES
# ------------------------------------------------------------------------------
# An IAM role is an IAM identity that you can create in your account that has
# specific permissions.
#
# AWS Documentation IAM:
#   - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
#   - https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
#   - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
#
# Terraform AWS Provider Documentation:
#   - https://www.terraform.io/docs/providers/aws/r/iam_role.html
#   - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
#   - https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
#   - https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
# ------------------------------------------------------------------------------

locals {
  _replace = ["/[^\\w+=,.@-]+/", "-"]

  r_name        = try(compact([var.role_name, var.name])[0], null)
  r_name_prefix = try(compact([var.role_name_prefix, var.name_prefix])[0], null)

  p_name        = try(compact([var.policy_name, var.name])[0], null)
  p_name_prefix = try(compact([var.policy_name_prefix, var.name_prefix])[0], null)

  ip_name        = try(compact([var.instance_profile_name, var.name])[0], null)
  ip_name_prefix = try(compact([var.instance_profile_name_prefix, var.name_prefix])[0], null)

  role_name        = try(replace(local.r_name, local._replace...), null)
  role_name_prefix = try(replace(local.r_name_prefix, local._replace...), null)

  policy_name        = try(replace(local.p_name, local._replace...), null)
  policy_name_prefix = try(replace(local.p_name_prefix, local._replace...), null)

  instance_profile_name        = try(replace(local.ip_name, local._replace...), null)
  instance_profile_name_prefix = try(replace(local.ip_name_prefix, local._replace...), null)
}

resource "aws_iam_role" "role" {
  count = var.module_enabled ? 1 : 0

  name                  = local.role_name
  name_prefix           = local.role_name_prefix
  assume_role_policy    = local.assume_role_policy
  force_detach_policies = var.force_detach_policies
  path                  = var.path
  description           = var.description
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary

  tags       = merge(var.module_tags, var.tags)
  depends_on = [var.module_depends_on]
}

locals {
  # set defaults
  _ec2_principles = [
    { type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  ]
  # compute defaults
  _create_assume_role_policy = var.module_enabled && var.assume_role_policy == null
  _assume_role_principals    = local.create_instance_profile ? local._ec2_principles : []
  _create_instance_profile   = var.instance_profile_name != null || var.instance_profile_name_prefix != null

  # translate variables to variables with defaults

  create_instance_profile = var.create_instance_profile != null ? var.create_instance_profile : local._create_instance_profile
  assume_role_policy      = local._create_assume_role_policy ? data.aws_iam_policy_document.assume_role_policy[0].json : var.assume_role_policy
  assume_role_principals  = length(var.assume_role_principals) > 0 ? var.assume_role_principals : local._assume_role_principals
}

data "aws_iam_policy_document" "assume_role_policy" {
  count = local._create_assume_role_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = var.assume_role_actions

    dynamic "principals" {
      for_each = local.assume_role_principals

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
  policy_enabled = var.module_enabled && (var.create_policy != null ? var.create_policy : length(var.policy_statements) > 0)
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

  name        = local.policy_name
  name_prefix = local.policy_name_prefix

  policy = data.aws_iam_policy_document.policy[0].json
  role   = aws_iam_role.role[0].name

  depends_on = [var.module_depends_on]
}

# Attach custom or managed policies
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count = var.module_enabled ? length(var.policy_arns) : 0

  role       = aws_iam_role.role[0].name
  policy_arn = var.policy_arns[count.index]

  depends_on = [var.module_depends_on]
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.module_enabled && local.create_instance_profile ? 1 : 0

  name        = local.instance_profile_name
  name_prefix = local.instance_profile_name_prefix
  path        = var.instance_profile_path

  role = aws_iam_role.role[0].name

  tags       = merge(var.module_tags, var.instance_profile_tags)
  depends_on = [var.module_depends_on]
}
