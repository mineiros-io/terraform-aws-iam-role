# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------

variable "assume_role_policy" {
  type        = string
  description = "(Required if assume_role_principals is not set) The policy that grants an entity permission to assume the role."
  default     = null
}

variable "assume_role_principals" {
  type = set(object({
    type        = string
    identifiers = list(string)
  }))
  description = "(Required if assume_role_policy is not set) Principals for the assume role policy."
  default     = []
}

variable "assume_role_conditions" {
  type = set(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  description = "(Optional) Conditions for the assume role policy."
  default     = []
}


# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "(Optional, Forces new resource) The name of the role. If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "name_prefix" {
  type        = string
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name."
  default     = null
}

variable "force_detach_policies" {
  type        = bool
  description = "(Optional) Specifies to force detaching any policies the role has before destroying it. Defaults to false."
  default     = false
}

variable "path" {
  type        = string
  description = "(Optional) The path to the role. See IAM Identifiers for more information."
  default     = "/"
}

variable "description" {
  type        = string
  description = "(Optional) The description of the role."
  default     = ""
}

variable "max_session_duration" {
  type        = number
  description = "(Optional) The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour (3600) to 12 hours (43200)."
  default     = 3600
}

variable "permissions_boundary" {
  type        = string
  description = "(Optional) The ARN of the policy that is used to set the permissions boundary for the role."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Key-value map of tags for the IAM role"
  default     = {}
}

# inline policy

variable "policy_statements" {
  type        = any
  description = "(Optional) List of IAM policy statements to attach to the User as an inline policy."
  default     = []
}

variable "policy_name" {
  type        = string
  description = "(Optional) The name of the role policy. If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "policy_name_prefix" {
  type        = string
  description = "(Optional) Creates a unique name beginning with the specified prefix. Conflicts with name."
  default     = null
}

# managed / custom policies

variable "policy_arns" {
  type        = list(string)
  description = "(Optional) List of IAM custom or managed policies ARNs to attach to the User."
  default     = []
}

# instance profile

variable "create_instance_profile" {
  type        = bool
  description = "(Optional) Whether to create an instance profile. Default is true if name or name_prefix are set else false."
  default     = null
}

variable "instance_profile_name" {
  type        = string
  description = "(Optional, Forces new resource) The profile's name. If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "instance_profile_name_prefix" {
  type        = string
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name."
  default     = null
}

variable "instance_profile_path" {
  type        = string
  description = "(Optional) Path in which to create the profile. Defaults to /"
  default     = "/"
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ------------------------------------------------------------------------------
variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is []."
  default     = []
}
