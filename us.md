# TrailPin - iOS Development Guide

## Executive Summary

TrailPin is a privacy-first GPS route tracker for outdoor enthusiasts who want a simple, battery-efficient way to record their hikes, bike rides, and walks. Unlike competitors that force account creation, charge expensive subscriptions, or collect user data, TrailPin keeps everything on-device with zero data collection. The app targets the US market primarily, with secondary markets in UK, Canada, Australia, and Europe.

**Key Differentiators**:
- Zero data collection — all data stays on device
- No account required — open and start tracking immediately
- Smart battery optimization — three power modes for 4-20 hours of tracking
- Free core features with one-time Pro upgrade ($3.99)
- Modern SwiftUI + SwiftData architecture for iOS 17+

## Competitive Analysis

| App | Strengths | Weaknesses | TrailPin Advantage |
|-----|-----------|------------|-------------------|
| Gaia GPS | Rich maps, offline support | $39.99/year subscription, complex UI, requires account | Free + simple + no account |
| AllTrails | Large trail database, community | $35.99/year, focuses on discovery not recording, requires account | Privacy-first, focused on recording |
| GPS Tracks | One-time $6.99, simple | Outdated UI, limited features, no battery optimization | Modern SwiftUI + smart battery |
| Geo Tracker | Affordable at $2.99/month | Subscription adds up ($35.88/year), limited iOS features | One-time $3.99 Pro, native iOS |
| Open GPX Tracker | Free, open source | Dated UI, no battery modes, slow updates | Modern design + battery optimization |
| komoot | Route planning, community | Complex interface, poor navigation, requires account | Minimalist, recording-focused |

## Apple Design Guidelines Compliance

- **Maps HIG**: Interactive map with zoom/pan, annotations for waypoints, overlays for route lines, Apple logo visibility preserved
- **Location Services HIG**: Clear permission request with purpose explanation, "While Using" and "Always" authorization, background location indicator enabled
- **Privacy HIG**: Zero data collection declared, no analytics SDKs, on-device storage only, transparent privacy policy
- **Accessibility HIG**: Dynamic Type support, VoiceOver labels on all controls, WCAG AA contrast ratios, 44pt minimum touch targets
- **Dark Mode HIG**: Full dark mode support with semantic colors, high contrast for outdoor readability
- **Liquid Glass (iOS 26)**: Translucent overlays for stats, modern rounded UI elements

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), MapKit, CoreLocation
- **Data**: SwiftData with @Model macro
- **Architecture**: MVVM + Service Layer
- **Observation**: @Observable (iOS 17 Observation framework)
- **Storage**: On-device only (SwiftData local persistence)
- **Networking**: None (fully offline app)
- **Background**: Location background mode for GPS tracking

## Module Structure

```
TrailPin/
├── App/
│   ├── TrailPinApp.swift
│   └── AppDelegate.swift
├── Models/
│   ├── Track.swift
│   ├── TrackPoint.swift
│   ├── Waypoint.swift
│   └── AppSettings.swift
├── Services/
│   ├── LocationManager.swift
│   ├── TrackRecorder.swift
│   ├── BatteryOptimizer.swift
│   ├── GPXExportService.swift
│   ├── GPXImportService.swift
│   └── CrashRecoveryService.swift
├── ViewModels/
│   ├── TrackingVM.swift
│   ├── TrackListVM.swift
│   ├── TrackDetailVM.swift
│   └── SettingsVM.swift
├── Views/
│   ├── MainTabView.swift
│   ├── TrackingView.swift
│   ├── TrackListView.swift
│   ├── TrackDetailView.swift
│   ├── MapView.swift
│   ├── SettingsView.swift
│   ├── PaywallView.swift
│   ├── ContactSupportView.swift
│   └── Components/
│       ├── RecordButton.swift
│       ├── StatsOverlay.swift
│       ├── BatteryIndicator.swift
│       ├── GPSSignalView.swift
│       └── WaypointSheet.swift
└── Extensions/
    ├── CLLocation+Extensions.swift
    ├── Color+Theme.swift
    └── Date+Formatting.swift
```

## Implementation Flow

1. Create SwiftData models (Track, TrackPoint, Waypoint, AppSettings)
2. Implement LocationManager with permission handling and GPS accuracy modes
3. Build MapView with SwiftUI Map and route polyline rendering
4. Implement TrackRecorder service for start/pause/stop recording
5. Create TrackingView with map, stats overlay, and record button
6. Build TrackListView with SwiftData query and track cards
7. Implement TrackDetailView with map preview and statistics
8. Add GPXExportService for route export via share sheet
9. Implement BatteryOptimizer with three power modes
10. Add background location tracking with proper Info.plist entries
11. Create SettingsView with unit toggle, power mode, and policy links
12. Implement GPXImportService for Pro users
13. Add PaywallView with StoreKit 2 for Pro upgrade
14. Create ContactSupportView with feedback backend
15. Add CrashRecoveryService for auto-save on interruptions
16. Polish UI with animations, haptics, and dark mode

## UI/UX Design Specifications

- **Color Scheme**:
  - Primary: Forest Green #2D6A4F, Vibrant Green #52B788
  - Secondary: Deep Blue-Gray #1B3A4B, Warm Orange #E76F51
  - Light Background: #FAFAF8, Dark Background: #1A1A2E
  - Semantic: Green (recording), Orange (paused), Red (stopped/warning), Blue (info)

- **Typography**:
  - Stats: SF Pro Display Bold 34pt
  - Headings: SF Pro Display Bold 20pt
  - Body: SF Pro Text Regular 16pt
  - Caption: SF Pro Text Light 13pt
  - Numbers: SF Mono for stable numeric transitions

- **Layout**:
  - Full-screen map with semi-transparent stats overlay
  - Large 56pt record button with 28pt corner radius
  - Bottom tab bar: Track / List / Settings
  - iPad: max content width 720pt centered
  - Minimum 44x44pt touch targets for outdoor use

- **Animations**:
  - Record button: green pulse (idle), red breathing (recording), orange blink (paused)
  - GPS signal: gray spin (searching), yellow (weak), green (strong)
  - Stats numbers: contentTransition(.numericText())
  - Route line: smooth extension as new points arrive

## Code Generation Rules

- Strict MVVM + Service Layer: View only displays, all logic in ViewModel/Service
- Use @Observable (iOS 17 Observation) not ObservableObject
- All distances stored internally as meters, converted in View layer only
- All times stored internally as seconds, converted in View layer only
- SwiftData models use @Model macro
- User preferences use @AppStorage
- Default GPS accuracy: balanced (kCLLocationAccuracyHundredMeters)
- Filter out points with horizontalAccuracy > 100m
- Background: allowsBackgroundLocationUpdates = true, showsBackgroundLocationIndicator = true
- Distance filter: 10m default, 50m for ultra-saving mode
- Zero data collection, no network requests, no third-party SDKs
- No comments in code unless explicitly requested

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.TrailPin
2. Verify Deployment Target: iOS 17.0
3. Configure Info.plist location permissions
4. Enable Background Modes (Location) capability
5. Generate app icon (1024x1024)
6. Build and test on iPhone XS Max simulator
7. Build and test on iPad Pro 13-inch (M4) simulator
8. Push to GitHub repository
9. Deploy policy pages to GitHub Pages
10. Prepare App Store Connect metadata
11. Generate App Store screenshots
