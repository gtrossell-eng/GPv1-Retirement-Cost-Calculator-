# Post-Deploy Smoke Tests

Run these checks after every deployment.

## API checks

1. GET `/api/health` returns 200 and JSON body with `status: "ok"`.
2. GET `/api/prices/search` with valid query returns 200 or 206.
3. GET `/api/prices/search` with invalid region returns 400.

## UI checks

1. Load the app and verify no startup error screen appears.
2. Add manual usage line and run pricing lookup.
3. Import sample CSV and verify one Blob row + excluded Azure Files row.
4. Export CSV, PDF, and JSON successfully.

## Security/headers checks

1. Verify response includes configured security headers.
2. Verify `Strict-Transport-Security` is active for HTTPS custom domain.

## Completion criteria

Deployment is considered healthy only when all checks pass.
