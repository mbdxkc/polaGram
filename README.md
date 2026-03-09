# polaGram

Instant photo app with vintage aesthetics. Capture, develop, caption, and share photos with a nostalgic instant camera feel.

## User Flow

```
Splash Screen → Tap pola frame → Camera/Library → Photo develops → Add caption → Share/Save
```

1. **Splash**: Tap or swipe to dismiss (plays welcome sound)
2. **Capture**: Tap the pola frame to take photo or choose from library
3. **Develop**: Watch photo appear over 20 seconds (shake to speed up)
4. **Caption**: Tap below photo to add 24-character handwritten caption
5. **Share**: Messages, Instagram Stories, or save to Photos + Gallery

## Features

| Feature | Description |
|---------|-------------|
| Camera | Native iOS camera or photo library picker |
| Development | 20-second animation with shake acceleration |
| Filters | 50 vintage effects with stacking (80% get 1+, 1% get "mangled") |
| Caption | 24-char limit, worn typewriter font effect |
| Gallery | Local persistence, swipeable stack layout |
| Sounds | System sounds for capture, develop, save, share |
| Haptics | Coordinated feedback on all interactions |
| Onboarding | 4-step tutorial for first-time users |
| Watermark | Optional "polaGram" badge (long-press save) |

## Architecture

```
polaGram/
├── polaGramApp.swift              # App entry, SwiftData container
├── ContentView.swift              # Main view controller
│
├── Components/                    # Reusable UI components
│   ├── ActionViews.swift          # ActionMenu, ActionButton
│   ├── BackgroundViews.swift      # PolaBackground, FilmGrainOverlay
│   ├── CameraView.swift           # Camera, MessageComposer, ShareSheet
│   ├── ChampagneBubbles.swift     # Animated particle system
│   ├── HeaderViews.swift          # PolaHeader, PolaLogo
│   ├── OverlayViews.swift         # SplashScreen, CaptionEditorOverlay
│   ├── PolaFrameViews.swift       # PolaFrame, StaticPolaFrame, WornText
│   └── ShakeDetector.swift        # CoreMotion observers
│
├── DesignSystem/                  # Design tokens and theming
│   ├── CharStyle.swift            # Deterministic text styling
│   ├── Colors.swift               # Brand colors, gradients
│   ├── Fonts.swift                # Custom typography
│   ├── Layout.swift               # Dimensions, spacing, scaling
│   ├── PolaFilters.swift          # 50 vintage filter definitions
│   ├── PolaTextures.swift         # Paper texture effects
│   └── Strings.swift              # All UI text (localization-ready)
│
├── Models/
│   └── SavedPola.swift            # SwiftData model
│
├── Views/
│   ├── GalleryView.swift          # Swipeable pola stack
│   └── OnboardingView.swift       # First-time tutorial
│
└── Services/
    └── SoundManager.swift         # System sounds + haptics
```

## Design System

### Colors
| Token | Hex | Usage |
|-------|-----|-------|
| polaPink | #E87DA0 | Primary brand |
| polaPinkLight | #F4B8C5 | Highlights |
| polaPinkHot | #E85A7E | Active states |
| polaSilverLight | #D9E0EB | Primary text |
| polaSilverDark | #BFCCE0 | Secondary text |
| polaGradientCenter | #8C878C | Background center |
| polaGradientEdge | #2D282D | Background edge |

### Typography
| Style | Font | Size |
|-------|------|------|
| polaTitle | System Bold | 24-32pt |
| polaBody | System Regular | 14-18pt |
| polaBodyBold | System Semibold | 14-18pt |
| polaCaption | American Typewriter | 16-18pt |

### Layout
| Constant | Value | Description |
|----------|-------|-------------|
| frameWidth | 312pt | Pola frame width |
| frameHeight | 392pt | Pola frame height |
| photoSize | 280pt | Photo area size |
| referenceWidth | 360pt | Base for scaling |
| minScale | 0.85 | iPhone SE |
| maxScale | 1.3 | iPad |

## Filters

50 vintage effects organized by category:

| Category | Filters |
|----------|---------|
| Coffee | ringStain, splatter, drip, poolStain |
| Burns | cigaretteBurn, edgeBurn, heatDamage, sparkBurn |
| Folds | cornerFold, centerCrease, multipleFolds, dogEar |
| Water | waterDrop, waterEdge, humidityWarp, rainSpots |
| Age | yellowedEdges, fadedCorner, vintageSepia, agedPaper |
| Sun | sunBleach, uvDamage, windowFade, overexposed |
| Tears | cornerTear, edgeTear, tornEdge |
| Scratches | lightScratch, deepScratch, scratchCluster |
| Light | lightLeak, prismLeak, apertureLeak |
| Dust | dustSpecs, fingerprint, lensSmudge |
| Chemical | developerStain, fixerSpots, chemicalDrip |
| Storage | rubberBandMark, paperClipIndent, stackPressure |
| Misc | penMark, inkSmudge, tapeMark, frameBleed |

## Sound Effects

| Event | Sound ID | Trigger |
|-------|----------|---------|
| Welcome | 1108 + 1001 | Splash screen appear |
| Shutter | 1108 | Photo capture |
| Develop | 1104 | Every 2 seconds during development |
| Save | 1407 + 1001 | Save to Photos complete |
| Share | 1001 | Messages/Instagram send |

Note: Requires physical device with ringer ON.

## Data Model

```swift
@Model
final class SavedPola {
    @Attribute(.externalStorage) var imageData: Data  // JPEG
    var caption: String
    var createdAt: Date
    var filterRawValue: Int?
}
```

Images stored externally for memory efficiency. Query sorted by `createdAt` descending.

## Platform Support

| Feature | iOS | macOS |
|---------|-----|-------|
| Camera | Yes | No |
| Photo Picker | Yes | Yes |
| Shake Detection | Yes | No |
| Save to Photos | Yes | NSSavePanel |
| Messages | Yes | No |
| Instagram | Yes | No |
| Haptics | Yes | No |
| Gallery | Yes | Yes |

## Requirements

- iOS 17.0+ / macOS 14.0+
- Xcode 15.0+
- Swift 5.9+

## Info.plist

```xml
<key>NSCameraUsageDescription</key>
<string>Take instant photos</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Save your polas</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Choose photos for your polas</string>

<key>NSMotionUsageDescription</key>
<string>Shake to develop photos faster</string>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>instagram-stories</string>
    <string>instagram</string>
</array>

<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>
```

## Build & Run

1. Open `polaGram.xcodeproj`
2. Select development team (Signing & Capabilities)
3. Build and run on physical device
4. Grant camera and photo permissions when prompted

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Feb 7, 2026 | Initial release |
| 1.1 | Feb 28, 2026 | Caption limit 24 chars, WornText effect |
| 1.2 | Feb 28, 2026 | Caption editor overlay, clear button |
| 1.3 | Feb 28, 2026 | Performance optimization, timer fixes |
| 1.4 | Feb 28, 2026 | Design tokens, accessibility |
| 1.5 | Mar 1, 2026 | Instagram Stories sharing |
| 1.6 | Mar 1, 2026 | 50 vintage filters |
| 1.7 | Mar 1, 2026 | SwiftData gallery |
| 1.8 | Mar 1, 2026 | Parallax, animations, color balance |
| 1.9 | Mar 1, 2026 | Accessibility polish |
| 2.0 | Mar 1, 2026 | Sounds, haptics, watermark, onboarding |
| 2.1 | Mar 1, 2026 | Branding update, code cleanup |
| 2.2 | Mar 7, 2026 | Modular architecture refactor, timer leak fix |
| 2.3 | Mar 9, 2026 | Stacked filter effects, "mangled" rare variant |
| 2.4 | Mar 9, 2026 | Sharpie caption icon, App Store submission ready |

---

mediaBrilliance 2026
