# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | TrailPin |
| **Git URL** | git@github.com:asunnyboy861/TrailPin.git |
| **Repo URL** | https://github.com/asunnyboy861/TrailPin |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/TrailPin/ | ✅ Active |
| Support | https://asunnyboy861.github.io/TrailPin/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/TrailPin/privacy.html | ✅ Active |

**Note**: Terms of Use not required for Paid Download apps (TrailPin uses one-time purchase model).

## Repository Structure

```
TrailPin/
├── TrailPin/                          # iOS App Source Code
│   ├── TrailPin.xcodeproj/            # Xcode Project
│   ├── TrailPin/                      # Swift Source Files
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Extensions/
│   │   └── Components/
│   └── ...
├── docs/                              # Policy Pages (GitHub Pages)
│   ├── index.html                     # Landing Page
│   ├── support.html                   # Support Page
│   └── privacy.html                   # Privacy Policy
├── TrailPin-pic/                      # App Store Screenshots
│   └── iphone/
│       ├── 01_tracking.png
│       ├── 02_track_list.png
│       ├── 03_settings.png
│       ├── 04_paywall.png
│       └── 05_track_detail.png
├── us.md                              # English Development Guide
├── keytext.md                         # App Store Metadata
├── capabilities.md                    # Capabilities Configuration
├── icon.md                            # App Icon Details
├── price.md                           # Pricing Configuration
└── nowgit.md                          # This File
```

## Deployment Summary

| Component | Platform | Status |
|-----------|----------|--------|
| iOS App Source Code | GitHub (main branch) | ✅ Pushed |
| Policy Pages | GitHub Pages (/docs) | ✅ Deployed |
| App Store Screenshots | Local (TrailPin-pic/) | ✅ Generated |

## App Store Connect

| Item | Value |
|------|-------|
| **App Name** | TrailPin |
| **Bundle ID** | com.zzoutuo.TrailPin |
| **Category** | Navigation / Health & Fitness |
| **Price Model** | Paid Download (One-time purchase) |
| **IAP Required** | No |
