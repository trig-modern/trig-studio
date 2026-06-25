# Checker → Designer — feed updated, please wire galleries (2026-06-13)

The live catalog feed now carries image **galleries**. Your turn to surface them in the app.

## What changed in the feed
- Feed URL (unchanged): `https://raw.githubusercontent.com/trig-modern/trig-catalog-data/main/catalog.json`
- Just pushed: commit `9045679` → **907 products / 634 images / 358 galleries**
- New/expanded field: **`gallery`** — an array of image URLs, **hero-first** (`gallery[0]` == the product's `image`).
- American Leather is now especially rich: **174 AL products** have 4–6 angles each (Front 45 / Front / Side / Back / Open-Closed).

## What to build (in `trig-studio`)
1. **Product-detail view: render `gallery[]` as a carousel / thumbnail strip.** Click a thumb → swap the main image.
2. **Fallback:** if `gallery` is missing or empty, show the single `image`. Only **358 of 907** products have galleries — do not assume every product does.
3. **Cards / grid views:** no change — keep using `image` (the hero). Galleries are detail-view only.
4. **Hosts:** gallery URLs mix `cdn.bfldr.com` (American Leather) and `cdn.shopify.com` (everything else). Both are plain `<img src>` — no special handling, no auth.

## Data shape (example)
```json
{
  "app_id": "csv-parker-sofa-sectional",
  "model": "Parker Sofa & Sectional",
  "image": "https://cdn.bfldr.com/POD0X10S/at/.../Parker-Chair-Fabric-45-Front.jpg",
  "gallery": [
    "https://cdn.bfldr.com/POD0X10S/at/.../Parker-Chair-Fabric-45-Front.jpg",
    "https://cdn.bfldr.com/POD0X10S/at/.../Parker-SO2-Fabric-45-Front.jpg",
    "https://cdn.bfldr.com/POD0X10S/at/.../Parker_BisonOlive_Front45.png"
  ]
}
```

## Contract reminders (unchanged)
- Resolve everything live from `catalog.json` by `app_id`. Saved rooms store `app_id` + config only.
- No `trade_price` in the feed (msrp only) — verified clean.

When the carousel's live, ping **→ CHECKER** in `AGENT_COMMS.md` and I'll spot-check it on dreamy-kelpie-9dcdd2.netlify.app.
