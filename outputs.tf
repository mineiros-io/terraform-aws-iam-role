# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "role" {
  description = "The aws_iam_role object."
  value       = try(aws_iam_role.role[0], null)
}

output "policy" {
  description = "The aws_iam_role_policy object."
  value       = try(aws_iam_role_policy.policy[0], null)
}

output "policy_attachments" {
  description = "The aws_iam_role_policy_attachment objects."
  value       = try(aws_iam_role_policy_attachment.policy_attachment, null)
}

output "instance_profile" {
  description = "The aws_iam_instance_profile object."
  value       = try(aws_iam_instance_profile.instance_profile[0], null)
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled"
  value       = var.module_enabled
}

output "module_tags" {
  description = "A map of tags that will be applied to all created resources that accept tags."
  value       = var.module_tags
}
