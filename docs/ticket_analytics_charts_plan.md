# Ticket analytics & charts (webapp home tile)

Plan for adding a **home dashboard tile** that opens **charts / analytics**, with **server-driven aggregates** instead of loading large ticket lists into the client.

Today the webapp loads tickets via **`TicketService.readAll`** (with filters). **`charts_weebi`** expects structured report-style data, not tens of thousands of raw `TicketPb` messages. Analytics should use **dedicated, bounded RPCs** that return pre-aggregated series for a **time range** and **scope**.

---

## 1. Goals and non-goals

### Goals

- A **home tile** that opens a **charts / analytics** experience for authorized users.
- **Server-authoritative** numbers: all aggregates come from the backend for the selected **time range** and **scope** (firm / chain / boutique), not from pulling every ticket into the browser.
- **Bounded payloads**: responses are **summary series** plus **small drill-down pages**, not full ticket lists unless the user explicitly drills in with pagination.

### Non-goals (initially)

- Offline-first or local persistence of ticket history for analytics.
- Porting every `charts_weebi` surface on day one; start with **one coherent dashboard** (e.g. sell/spend totals over time).

---

## 2. Architecture principle

**Analytics are a different read model than “list tickets”.**

| Concern | List tickets (existing) | Charts (new) |
|--------|------------------------|--------------|
| Primary use | Browse, search, open one ticket | Trends, comparisons, KPIs |
| Data shape | Many rows, rich `TicketPb` | Few rows: **bucket × metrics** |
| Volume | Capped by filters + pagination | **Always capped** (max buckets, max drill-down rows) |
| Where computed | Server returns row-oriented data | Server returns **pre-aggregates** |

Do **not** drive charts by widening `readAll` across huge date ranges. Introduce **dedicated RPCs** (or a versioned analytics service) whose responses are **aggregate DTOs only**.

---

## 3. Backend (weebi_server + protos)

### 3.1 Analytics RPCs (versioned)

Illustrative names and shapes:

- **`GetTicketAnalyticsSummary`** — inputs: `firm_id`, optional `chain_id` / `boutique_ids`, `time_range`, `granularity` (day / week / month), `metric_set` (e.g. sells, spends, counts, TTC in boutique currency).
- Optional: **`GetTicketAnalyticsBreakdown`** — same filters + **dimension** (e.g. by boutique, by payment type) with **top-N + “other”**.

### 3.2 Response design

Return **compact proto messages**, e.g. repeated `{ bucket_start, sell_total, spend_total, ticket_count, currency }` instead of tickets.

If multi-currency boutiques matter:

- pick one **reporting currency** per request with documented server-side conversion, or  
- return one series per **ISO 4217** (document behavior explicitly).

### 3.3 Query implementation

- Storage queries must be **indexed** on business keys: date / `creationDate`, `boutiqueId`, `chainId`, `firmId`, `ticketType`, status, etc.
- Use aggregation **by date bucket** (e.g. Mongo `$group`), or pre-aggregated collections in a later phase.
- Enforce **hard limits**: maximum range length, maximum buckets, maximum breakdown rows; return `INVALID_ARGUMENT` (or equivalent) when exceeded.

### 3.4 Authorization

Reuse the same rules as ticket reads, including **operational license / seat** gating where multi-boutique access applies. Analytics must **never** expose aggregates for boutiques the principal cannot access.

### 3.5 Performance path

- **MVP**: on-the-fly aggregation with correct indexes.
- **Later**: **materialized rollups** (scheduled or incremental) if latency or load requires it.

---

## 4. Webapp — data flow

### 4.1 Home tile

- New route (e.g. `/analytics` or `/charts`).
- A **tile** on the existing home/dashboard grid: icon, title, **l10n**, optional state when license blocks access (aligned with operational license UX elsewhere).

### 4.2 Charts screen

- **Controls**: date presets (7d / 30d / month / custom), granularity where relevant, scope (allowed boutiques vs. picker consistent with `TicketsBoutiqueCache` / firm context).
- **Loading**: invoke new gRPC methods when filters change; **debounce** free-form date inputs.
- **State**: last successful summary + loading/error; optional short **in-memory TTL cache** keyed by `(range, scope, metric_set)` to reduce duplicate calls when navigating back.

### 4.3 `charts_weebi` integration

- Prefer a **thin mapper** from new protos to the chart widgets (either in the webapp or as a small adapter inside `charts_weebi`).
- Avoid tying server protos directly to `models_weebi` internals; keep a clear boundary.

---

## 5. Operational and UX details

- **Empty / sparse data**: dedicated empty state, not a broken chart.
- **Loading**: skeleton or progress on first load; lighter indicator on subsequent range changes.
- **Errors**: permission, range too large, timeouts — consistent with global gRPC handling (including operational license overlay if applicable).
- **Export / PDF** (package already depends on printing stack): **phase 2** once the summary API is stable.

---

## 6. Phased rollout

| Phase | Scope |
|-------|--------|
| **P0** | Protos + server: one summary RPC (single granularity), firm/chain/boutique filters, indexes. Webapp: tile + screen with **one** chart (e.g. sell total per day). |
| **P1** | Breakdown RPC (top boutiques or types), second chart, tighter validation and error surfacing. |
| **P2** | Server rollups / caching; export; extra metrics (margin, tax buckets) as product needs. |

---

## 7. Dependencies and risks

- **Indexes and load** on production ticket data must be validated at realistic volume.
- **Semantic date** (ticket `date` vs `creationDate`) must be specified so product, server, and UI agree.
- **Multi-boutique / license** behavior must match ticket list semantics.

---

## 8. Explicitly deferred

- Client-side aggregation from bulk `readAll` over large windows.
- “Load everything, then chart” for large firms.
- Full parity with every chart type in `charts_weebi` before the analytics API is proven.

---

*This document describes intent only; implementation should follow existing repo conventions for protos, fence/billing gates, and Docker (full repo `COPY` already includes `packages/charts_weebi`).*
