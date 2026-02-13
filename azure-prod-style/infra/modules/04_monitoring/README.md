# Monitoring Module

## Purpose
Creates centralized observability resources.

## Creates
- Log Analytics Workspace.
- Workspace-based Application Insights.

## Required inputs
- `law_name`
- `app_insights_name`
- `location`
- `resource_group_name`

## Outputs
- `law_id`
- `law_workspace_id`
- `app_insights_id`
- Sensitive: `app_insights_connection_string`, `app_instrumentation_key`
