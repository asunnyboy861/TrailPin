# Pricing Configuration

## Monetization Model: Free + Non-Consumable IAP

- **Price**: Free download with one-time Pro upgrade
- **IAP**: Yes - Non-consumable (one-time purchase, no subscription)
- **Subscription**: None

## Free Tier Features

- GPS route recording (unlimited time)
- Real-time stats (distance, time, speed, altitude)
- Pause/resume recording
- Waypoint adding (max 5 per track)
- Track history list (max 10 tracks)
- GPX file export
- Three battery optimization modes
- Dark mode support
- Miles/kilometers toggle

## In-App Purchase

### TrailPin Pro (Non-Consumable)

- **Reference Name**: TrailPin Pro
- **Product ID**: `com.zzoutuo.TrailPin.pro`
- **Type**: Non-consumable (one-time purchase)
- **Price**: $3.99 (Tier 3)

### Localization (English - US)

| Field | Value | Max Chars | Status |
|-------|-------|-----------|--------|
| **Display Name** | TrailPin Pro | 30 | ✅ 12 chars |
| **Description** | Unlock all features with one-time purchase | 45 | ✅ 43 chars |

### Pro Features

- All free tier features
- Unlimited waypoints
- Unlimited track history
- GPX file import
- CSV data export
- Offline map cache
- Route color customization
- Elevation profile chart
- Speed/altitude charts
- Crash auto-recovery
- Route editing (name, color, delete)
- Batch export

## App Store Connect Pricing

- **App Price Tier**: Free (download)
- **IAP Price Tier**: Tier 3 = $3.99 (non-consumable)

## Policy Pages Required

| Page | Required | Reason |
|------|----------|--------|
| Support Page | ✅ Yes | All apps require support |
| Privacy Policy | ✅ Yes | All apps require privacy policy |
| Terms of Use | ❌ No | Not required for non-consumable IAP (only subscription apps need Terms) |

## Apple IAP Compliance Checklist

- [x] Restore purchases functionality implemented
- [x] No auto-renewal terms needed (non-consumable, not subscription)
- [x] No cancellation instructions needed (one-time purchase)
- [x] Pricing clearly stated in app
- [x] No free trial (not applicable to non-consumable)
- [x] Display Name ≤ 30 characters
- [x] Description ≤ 45 characters

## Pricing Rationale

| Competitor | Price | Our Advantage |
|------------|-------|---------------|
| GPS Tracks | $6.99 one-time | $3.99 is 43% cheaper |
| Gaia GPS | $39.99/year | $3.99 one-time = massive savings |
| Geo Tracker | $2.99/month ($35.88/year) | $3.99 one-time = 89% savings |

- Free tier covers core needs - zero pressure to try
- Pro features are "nice to have" not "must have" - no resentment
- One-time purchase appeals to users who hate subscriptions
