# Monitoring and Alerting

## Required telemetry

Track these signals in Application Insights:

- Request count, latency, and failure rate for `/api/prices/search`
- Status code distribution (400, 429, 502, 206)
- Unhandled exceptions in API runtime
- Deployment success/failure events from CI

## Recommended alerts

- API error-rate spike (5xx above baseline)
- Sustained latency increase for pricing lookup endpoint
- Repeated upstream Azure Retail Prices failures
- Unusual request-volume spikes indicating abuse
- Failed production deployment workflow

## Data handling guardrails

Do not log:

- Customer notes
- Full imported CSV/JSON payload contents
- Local storage contents

## Operational review cadence

- Weekly: review dependency and security scan results
- Weekly: review API error and latency trends
- Monthly: test rollback procedure and verify runbooks remain accurate
