variable "role_assignments" {
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
  description = "RBAC role assignments map."
}

