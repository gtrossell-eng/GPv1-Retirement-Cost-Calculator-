# Azure IaC Baseline

This folder contains a baseline Bicep template for repeatable provisioning in Azure.

## What it provisions

- Application Insights component
- Storage account for Azure Functions runtime storage
- Azure Functions app (Node 20)
- Optional App Service plan + web app when `deploymentMode=split`
- Optional Azure Static Web App when `deploymentMode=swa`

## Deployment modes

- `swa`: Azure Static Web Apps managed web + managed API path
- `split`: App Service-hosted web app + standalone Azure Functions app

## Deploy

```powershell
az deployment group create \
  --resource-group <resource-group> \
  --template-file infra/azure/main.bicep \
  --parameters deploymentMode=swa environmentName=prod appName=gpv2estimator
```

For split mode:

```powershell
az deployment group create \
  --resource-group <resource-group> \
  --template-file infra/azure/main.bicep \
  --parameters deploymentMode=split environmentName=prod appName=gpv2estimator
```

After provisioning, deploy application artifacts from CI and set platform-specific settings described in `docs/deployment.md`.
