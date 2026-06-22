# Production Deployment Checklist

## Pre-deployment

- Confirm branch protection requires successful CI checks.
- Confirm GitHub secrets are configured (deployment token and any environment secrets).
- Run `npm ci`, `npm run test`, `npm run typecheck`, `npm run lint`, `npm run build`, and `npm run audit:prod`.
- Confirm no high or critical production dependency vulnerabilities.
- Confirm API base URL strategy (`VITE_API_BASE_URL`) for target topology.

## Azure provisioning

- Provision resources with `infra/azure/main.bicep` using the correct `deploymentMode`.
- Configure Functions app settings:
  - `FUNCTIONS_WORKER_RUNTIME=node`
  - `FUNCTIONS_EXTENSION_VERSION=~4`
  - `APPLICATIONINSIGHTS_CONNECTION_STRING`
- Configure frontend hosting route/proxy behavior for `/api/*`.
- Configure TLS/custom domain if required.

## Post-deployment validation

- Run smoke tests in `docs/post-deploy-smoke-tests.md`.
- Verify `/api/health` returns HTTP 200.
- Verify pricing lookup works from UI and from API endpoint.
- Verify exports (CSV/PDF/JSON) still work.
- Verify Application Insights receives requests and failures.

## Go-live

- Confirm rollback path is documented and tested.
- Confirm alerts are enabled for API errors and deployment failures.
- Record deployment version, timestamp, and operator.
