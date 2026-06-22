# Deployment

## Hosting modes

This app supports multiple Azure hosting patterns:

1. **Azure Static Web Apps (recommended default)**
   - Frontend and managed API under same origin.
   - Use `VITE_API_BASE_URL=/api`.

2. **Split App Service + Azure Functions**
   - Frontend deployed to App Service (or static host).
   - API deployed to standalone Functions app.
   - Use reverse proxy for `/api/*` or set `VITE_API_BASE_URL` to the full API base URL.

3. **Front Door / Application Gateway fronted split deployment**
   - Keep same-origin routing by terminating traffic at shared edge and routing `/api/*` to Functions.

## Infrastructure provisioning

Use the baseline Bicep template in `infra/azure/main.bicep`.

### Example deployment (Static Web Apps mode)

```powershell
az deployment group create \
  --resource-group <resource-group> \
  --template-file infra/azure/main.bicep \
  --parameters deploymentMode=swa environmentName=prod appName=gpv2estimator
```

### Example deployment (Split mode)

```powershell
az deployment group create \
  --resource-group <resource-group> \
  --template-file infra/azure/main.bicep \
  --parameters deploymentMode=split environmentName=prod appName=gpv2estimator
```

## Application settings

### Web (`apps/web`)

- `VITE_API_BASE_URL` (optional): API base path or absolute URL.
  - Default: `/api`
  - For split origins: `https://<your-functions-host>/api`

### API (`apps/api`)

Required runtime settings:

- `FUNCTIONS_WORKER_RUNTIME=node`
- `FUNCTIONS_EXTENSION_VERSION=~4`
- `AzureWebJobsStorage=<storage connection string>`
- `APPLICATIONINSIGHTS_CONNECTION_STRING=<from App Insights>`

Use Node.js 20 or later.

## Access-control modes

- **Public mode**: anonymous app + API access.
- **Private preview mode**: enforce authentication at hosting layer before app/API access.
- **Internal mode**: restrict access to approved identities/tenant.

For SWA private/internal modes, update route authorization in `staticwebapp.config.json` and identity provider settings.

## CI/CD and deployment gates

The repository workflow already runs:

- `npm ci`
- `npm run test`
- `npm run typecheck`
- `npm run lint`
- `npm run audit:prod`
- `npm run build`

Recommended merge protection: require these checks and CodeQL to pass before merge.

## Local verification before deployment

Run:

```powershell
npm install
npm run test
npm run typecheck
npm run lint
npm run build
```

## Post-deployment verification

Run smoke tests from `docs/post-deploy-smoke-tests.md` and verify `/api/health` returns HTTP 200.

## Operations runbooks

- Production checklist: `docs/production-checklist.md`
- Monitoring and alerts: `docs/monitoring-and-alerting.md`
- Incident response and rollback: `docs/incident-response-and-rollback.md`
- Repo/platform settings: `docs/repo-platform-settings.md`
