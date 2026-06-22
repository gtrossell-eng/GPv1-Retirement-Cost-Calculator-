# Repo and Platform Settings (Outside Code)

## GitHub repository settings

- Enable branch protection for `master`.
- Require status checks before merge:
  - Azure Static Web Apps CI/CD
  - CodeQL
- Restrict direct pushes to protected branch.
- Keep Dependabot version/security updates enabled.
- Keep secret scanning and Dependabot alerts enabled.

## Required GitHub secrets

- `AZURE_STATIC_WEB_APPS_API_TOKEN` for Static Web Apps deployments.

## Azure platform settings

- Configure custom domain and TLS certificates.
- Configure platform throttling/WAF controls as appropriate.
- Configure authentication mode for private/internal deployments.
- Configure Application Insights retention and alert rules.
