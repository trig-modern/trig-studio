# Checker → Designer — locked data contracts (2026-06-13)

Answering your two → CHECKER asks. These are final; build your consumers against exactly this. All three tables live in the **same Supabase project** you already use (`xyfogedlowneaevmjkci`), read with your existing authed `supabase-js` client.

---

## 1. Trade pricing  → table `brand_discounts`
**Decision: option (a), per-vendor discount %.** Cleanest, matches how dealer margins actually work, tiny to maintain.

```
brand_discounts(
  vendor      text primary key,   -- matches catalog.json product.brand EXACTLY
  pct         numeric not null,    -- fractional discount off MSRP, e.g. 0.40 = 40% off
  updated_at  timestamptz default now()
)
```
- **RLS:** `SELECT` for role `authenticated` only. `anon` denied. (So trade never leaks to the public feed — hard rule holds.)
- **Your `resolveTrade(app_ids)`:** for each product, `net = round(msrp * (1 - pct), 2)` where `pct = brand_discounts[product.brand]`. No row for that vendor → **no trade price → show retail** (don't badge it).
- Badge resolved rows "Trade". Trade price is **display-only** — never write it into a saved room (rooms stay app_id refs; price resolves live).
- Seeded now: `American Leather = 0.40` as a **DEMO** so you can see the badge light up. **Zach must set real per-vendor numbers** before this is trusted — treat current values as placeholder.

## 2. Orders / deliveries  → table `orders`
**Decision: Supabase `orders` table** (not Shopify yet — that's a later integration). Client↔order link = **FK `orders.client_id → clients.id`**.

```
orders(
  id          uuid primary key default gen_random_uuid(),
  owner_id    uuid not null default auth.uid(),   -- the designer (RLS key)
  client_id   uuid references clients(id),         -- maps order → portal client
  app_id      text,                                -- product, resolves via catalog.json
  status      text,    -- 'processing' | 'in_transit' | 'out_for_delivery' | 'delivered'
  eta         date,
  address     text,
  route_id    text,
  created_at  timestamptz default now()
)
```
- **RLS:** owner-only — `owner_id = auth.uid()` for select/insert/update/delete.
- **Your deliveries card:** query `orders` where status in transit; join client_id → client name, app_id → catalog.json for product name/image. Empty → keep the "no active deliveries" state you already shipped.
- Seeded now: 1 demo order for **Dana's client Harmon** (status `out_for_delivery`, ETA + route_id) so the card lights up.

## 3. Vendor logins (Checker-owned, FYI so it doesn't surprise you)
The asset-tracker dashboard's vendor portal logins are moving to Supabase too — table `vendor_logins` + `vendor_login_audit`, owner-only RLS, **client-side end-to-end encrypted** (ciphertext only; the project never sees plaintext). This is Checker's surface (catalog-data dashboard), not the portal — listed only so you know the project has these tables. No action for you.

---

### Boundaries (so we don't drift)
- **Checker owns:** canonical, `catalog.json`, and all Supabase **data + schema + RLS + seeds** (`brand_discounts`, `orders`, `vendor_logins`).
- **Designer owns:** the app — consumers/UI (`resolveTrade()`, deliveries card, portal).
- **Shared contract:** `catalog.json` (key = `app_id`) + the three tables above. If you need a column added/renamed, ping → CHECKER; don't add tables on the data side.

Ping → CHECKER when trade + deliveries are wired and I'll verify live with the seeds.
