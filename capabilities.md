# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- GPS tracking requires Location Services (Always + When In Use)
- Background tracking requires Background Modes (Location)
- No iCloud/sync mentioned
- No push notifications needed
- No HealthKit needed
- No camera/photo library needed
- No Apple Watch companion (Phase 3+)
- In-App Purchase needed for Pro upgrade

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| Location Services (When In Use) | Configured via Info.plist | NSLocationWhenInUseUsageDescription |
| Location Services (Always) | Configured via Info.plist | NSLocationAlwaysAndWhenInUseUsageDescription |
| Background Modes (Location) | Configured via Info.plist | UIBackgroundModes: location |
| In-App Purchase | Will configure in code | StoreKit 2 |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| In-App Purchase (App Store Connect) | Pending | Create product in App Store Connect: com.zzoutuo.TrailPin.pro |

## No Configuration Needed

- Push Notifications (not needed)
- iCloud / CloudKit (not needed - all data local)
- HealthKit (not needed)
- Camera / Photo Library (not needed)
- Siri (not needed)
- Apple Watch (future phase)
- Sign in with Apple (not needed - no account)

## Verification
- Build succeeded after configuration: Pending
- All entitlements correct: Pending
