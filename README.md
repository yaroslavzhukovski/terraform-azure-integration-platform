# Enterprise Azure Integration Platform

## Project Summary

This portfolio project demonstrates how I design and deliver a production-style Azure integration platform with business priorities in mind: reliability, security, operational visibility, and delivery speed.

It is not a demo of isolated resources. It is an end-to-end platform built to support real message-driven business workflows.

Scope note:

- This project is platform-first. The application code is intentionally minimal and included to prove platform behavior and integration flow.
- The workloads are technical validation components, not business-feature-complete products.

## What Was Built

The environment in `infra/live/main` deploys:

- API layer on Azure App Service.
- Event backbone with Azure Service Bus queue.
- Azure Function App (Flex Consumption) for event handling.
- Azure Container App for downstream message processing.
- Azure Storage Account for processed data and deployment storage.
- Azure Container Registry for private image distribution.
- Private networking, private DNS zones, and private endpoints.
- Centralized observability with Log Analytics and Application Insights.
- Managed identities and RBAC role assignments.

## Architecture Flow

Business request flow:

1. Client request enters the App Service API.
2. API publishes a message to Service Bus.
3. Function App consumes queue messages.
4. Function App calls the Container App.
5. Container App processes and stores output in Azure Storage.
6. Logs and telemetry are collected centrally for operations.

## Architecture Diagram

![Enterprise Azure Integration Platform Architecture](azure-prod-style/diagram/diagram1.svg)

## Security Implementation

Security was implemented as a design baseline, not as an afterthought.

Key controls in this project:

- Identity-first access: managed identities for workload-to-workload communication.
- Least-privilege authorization: explicit RBAC assignments for Function App, Container App, and API integration paths.
- Network isolation: private endpoints and private DNS for core services.
- Reduced public surface: public access disabled or restricted where supported by service design.
- Transport hardening: TLS minimums and secure defaults in service configuration.
- Traceability: diagnostic settings wired to centralized monitoring.

Policy and identity assumptions:

- This solution assumes an enterprise landing zone already exists.
- Organization-wide governance policies are expected to be managed centrally by the platform/security team.
- Corporate users, groups, and baseline access models are assumed to be pre-established.
- RBAC in this project is focused on runtime permissions required for application components to operate correctly.

## Business Impact

This architecture supports business needs in practical terms:

- Reliability: asynchronous messaging protects workloads during spikes and transient failures.
- Risk reduction: private connectivity and identity-based auth reduce exposure.
- Faster delivery: reusable Terraform modules reduce setup time for future environments.
- Better operations: centralized telemetry reduces mean time to detect and resolve incidents.
- Governance readiness: standardized naming, tags, and IaC improve auditability.

## My Contribution

I owned the solution from architecture to implementation:

- designed the architecture and security model
- implemented modular Terraform structure
- wired runtime identities and permissions
- integrated observability and operational outputs
- documented deployment and platform behavior
- intentionally kept app code lightweight to validate platform capability rather than deliver full product functionality

## Repository Layout

- `infra/modules`: reusable Terraform modules.
- `infra/live/main`: deployable environment composition.
- `app/appservice-api`: API workload.
- `app/function/ServiceBusToContainer`: event-driven Function workload.
- `app/container-message-processor`: containerized processing workload.

## Where To Review First

- `infra/live/main/README.md`
- `infra/live/main/main.tf`
- `infra/live/main/terraform.tfvars.example`
