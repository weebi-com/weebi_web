# Secrets & Configuration

Envoy proxy URLs and other sensitive values must **never** be committed. Configure them via:

- **Production (Cloud Run)**: Environment variables / Secret Manager
- **CI/CD (GitHub Actions)**: Repository secrets
- **Local development**: Gitignored dotenv files

---

## Production (Google Cloud Run)

Set these as environment variables or [Secret Manager](https://cloud.google.com/secret-manager) references:

| Variable | Required | Description |
|----------|----------|-------------|
| `API_URL` | Yes* | Envoy proxy URL (e.g. `https://weebi-envoyproxy-prd-xxx.run.app`) |
| `API_URL_DEV` | If using ENVIRONMENT | Dev Envoy URL (use when `ENVIRONMENT=development`) |
| `API_URL_PRD` | If using ENVIRONMENT | Prod Envoy URL (use when `ENVIRONMENT=production`) |
| `ENVIRONMENT` | Optional | `development` or `production` – used to pick `API_URL_DEV` / `API_URL_PRD` |
| `LOCALE` | No | Default locale (default: `fr`) |

\* Either set `API_URL` directly, or set `ENVIRONMENT` + `API_URL_DEV`/`API_URL_PRD`.

**Example (direct URL):**
```bash
gcloud run deploy weebi-webapp --set-secrets "API_URL=envoy-url-prd:latest"
```

**Example (via ENVIRONMENT + secrets):**
```bash
gcloud run deploy weebi-webapp \
  --set-env-vars "ENVIRONMENT=production" \
  --set-secrets "API_URL_PRD=envoy-url-prd:latest"
```

---

## GitHub Actions / CI

Add these as [repository secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets):

| Secret | Description |
|--------|-------------|
| `API_URL` | Envoy proxy URL for the deployed environment |
| `API_URL_DEV` | Dev Envoy URL (if building for dev) |
| `API_URL_PRD` | Prod Envoy URL (if building for prod) |

Use them when building/deploying:
```yaml
env:
  API_URL: ${{ secrets.API_URL_PRD }}
```

---

## Local Development

1. Copy the example files:
   ```bash
   cp assets/dotenv_dev.txt.example assets/dotenv_dev.txt
   cp assets/dotenv_prd.txt.example assets/dotenv_prd.txt
   ```

2. Obtain the Envoy URL from your team and add it to `assets/dotenv_dev.txt`:
   ```
   API_URL=https://your-envoy-url.run.app
   LOCALE=fr
   ```

3. **Do not commit** `dotenv_dev.txt` or `dotenv_prd.txt` – they are gitignored.

---

## Config Flow Summary

| Context | Config source | Secrets from |
|---------|---------------|--------------|
| **Cloud Run** | `/config.json` (generated at startup) | Env vars / Secret Manager |
| **Local `flutter run`** | `assets/dotenv_*.txt` | Local files (gitignored) |
| **Docker build** | Uses `.example` files (empty URLs) | N/A – runtime uses env vars |
