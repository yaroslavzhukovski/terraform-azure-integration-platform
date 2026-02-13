# Role Assignments Module

## Purpose
Reusable wrapper for bulk RBAC assignment creation.

## Creates
- `azurerm_role_assignment` for each map item in `role_assignments`.

## Required input
- `role_assignments` map of objects with:
- `scope`
- `role_definition_name`
- `principal_id`

## Current limitation
`outputs.tf` still contains a TODO and no outputs are exposed yet.
