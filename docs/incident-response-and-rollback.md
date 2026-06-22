# Incident Response and Rollback

## Incident triggers

- Elevated 5xx responses from `/api/prices/search`
- Repeated Azure Retail Prices upstream failures
- Pricing lookup failures reported by users
- Failed deployment or broken post-deploy smoke tests

## Initial triage

1. Confirm current release SHA and deployment timestamp.
2. Check Application Insights for request failures and error spikes.
3. Check platform health (Static Web Apps/App Service/Functions runtime status).
4. Run `/api/health` to verify API liveness.

## Mitigation actions

- If only frontend is affected, redeploy the previous known-good web artifact.
- If API is degraded, redeploy previous known-good Functions artifact.
- If upstream pricing API is failing, communicate degraded mode expectations (cached results may be served).
- If abuse traffic is suspected, tighten platform throttling/WAF rules.

## Rollback steps

1. Identify last known-good build from CI.
2. Redeploy known-good web artifact.
3. Redeploy known-good API artifact.
4. Re-run post-deploy smoke tests.
5. Confirm error rates return to baseline.
6. Document root cause and remediation tasks.

## Communication

- Post customer-facing status update with impact and ETA.
- Capture incident timeline, mitigation, and follow-up action items.
