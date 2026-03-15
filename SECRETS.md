# Secrets & Configuration

API_URL is **hardcoded** in `lib/config/api_url.dart`. Change it when merging between dev and prod (git merge triggers the build; no build args).

- **Deployed & local**: Uses `kApiUrl` from that file. Dev branch = dev URL, prod/main = prod URL.

---

## Hardcoded API_URL

**File:** `lib/config/api_url.dart`

| Branch / env | Set `kApiUrl` to |
|-------------|-------------------|
| **Dev** | `https://weebi-envoyproxy-dev-29758828833.europe-west1.run.app` |
| **Prod** | `https://weebi-envoyproxy-prd-29758828833.europe-west1.run.app` |

When you merge dev → prod (or prod → dev), update this constant so the built app points to the correct Envoy. Merge then triggers the build with the right URL.

---

## Config flow summary

| Context | API_URL source |
|---------|----------------|
| **All** | `lib/config/api_url.dart` (`kApiUrl`). Change when merging dev ↔ prod. |
| **Fallback** | If `kApiUrl` empty: config.json (then empty). |
