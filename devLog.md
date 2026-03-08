# polaGram Development Log

## Project Overview

**polaGram** is a SwiftUI iOS/iPadOS/macOS app that creates shareable pola-style photo frames with handwritten captions and vintage date stamps. The app captures the nostalgic experience of instant film photography, complete with a simulated development process.

---

## Architecture

### Design Philosophy
- **Token-based design system**: Colors, fonts, and layout values centralized in extensions/structs
- **Component-driven**: Each visual element is a reusable SwiftUI view
- **Responsive scaling**: GeometryReader with clamped scale factor (0.85x - 1.3x)
- **Platform abstraction**: `#if canImport(UIKit/AppKit)` for cross-platform support

### File Structure
```
polaGram/
├── ContentView.swift     # All UI components (~1850 lines)
├── Assets.xcassets/      # App icons, colors, pG_logo
└── Info.plist            # Privacy usage descriptions
```

### Key Components
| Component | Purpose |
|-----------|---------|
| `ContentView` | Root view, manages all state and flow |
| `PolaBackground` | Animated gradient, vignettes, bubbles, grain |
| `PolaFrame` | Interactive pola frame with photo/caption areas |
| `StaticPolaFrame` | Non-interactive version for ImageRenderer |
| `WornText` | Hemingway typewriter character effect |
| `CaptionEditorOverlay` | Semi-transparent caption input |
| `ActionMenu` | Share/save buttons |
| `ShakeDetector` | CoreMotion accelerometer monitoring |
| `CameraView` | UIImagePickerController wrapper |

---

## Version History

### v1.0 - Design Freeze (February 7, 2026)
**Milestone: Core design system complete**

- Established color tokens (pink gradient scheme, warm moody tones)
- Typography system (BradleyHandITCTT, AvenirNextCondensed, MarkerFelt)
- Layout constants for responsive scaling
- Component architecture finalized
- Splash screen with dismiss gestures
- Photo placeholder with "tap to snap" prompt

### v1.1 - Caption Update (February 28, 2026)
**Focus: Authentic handwritten caption aesthetic**

#### Caption Limit Reduction
- Changed from 42 to 24 characters
- Rationale: Real Sharpie-on-pola captions are short and punchy
- Updated placeholder phrases to match new limit

#### WornText Component
Created "broken Hemingway typewriter" effect:
- **Irregular letter spacing**: Some overlap (-8%), some gap (+3%)
- **Stuck keys**: ~12.5% of letters drop below baseline
- **Worn ribbon**: Ink density varies 45-85% per character
- **Misaligned typebars**: ±2.5° rotation per letter
- **Carriage slip**: Subtle horizontal jitter

#### Bold Compensation
Smaller text gets heavier treatment:
- Ink density increases (up to 70-100% at minimum size)
- Blur decreases (sharper edges = fresh Sharpie look)
- Shadow opacity increases

#### Bug Fix: Message Share Crash
**Problem**: First tap on message button crashed the app
**Cause**: SwiftUI sheet presented before image was fully rendered
**Solution**: Changed from `sheet(isPresented:)` to `sheet(item:)` pattern
```swift
// Before (crashed on first tap)
.sheet(isPresented: $showMessageSheet) { ... }

// After (image guaranteed ready)
.sheet(item: $messageImageItem) { item in ... }
```

### v1.2 - UX Polish (February 28, 2026)
**Focus: Improved interaction patterns**

#### Caption Editor Overlay
- Changed from modal sheet to semi-transparent overlay
- Pola frame stays visible beneath (provides context)
- Tap backdrop to cancel
- Slide-up card with cancel/done buttons
- Noteworthy-Bold font for input consistency

#### Clear Photo Button
- X button appears on photo (top-right corner)
- Only visible when photo exists and not developing
- Resets: photo, caption, development state, picker selection
- Light haptic feedback on tap

#### Responsive Scaling
- GeometryReader calculates scale factor from screen width
- Reference width: 360pt (iPhone standard)
- Scale clamped: 0.85x minimum, 1.3x maximum
- All layout values multiplied by scale factor

### v1.3 - Code Audit & Optimization (February 28, 2026)
**Focus: Performance and code quality**

#### Dead Code Removal
- **CaptionEditorView**: Removed 200+ lines of unused full-screen editor
  (replaced by CaptionEditorOverlay in v1.2)
- **accelerateDevelopment()**: Removed unused function
- **Duplicate imports**: Removed redundant UIKit import

#### Memory & Performance Fixes

**Timer Retain Cycle**
```swift
// Before (retain cycle)
Timer.scheduledTimer(...) { _ in
    self.developmentProgress += increment
}

// After (weak reference)
Timer.scheduledTimer(...) { [weak self] _ in
    guard let self = self else { return }
    self.developmentProgress += increment
}
```

**ChampagneBubbles Optimization**
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Timer frequency | 100fps | 30fps | 3x less CPU |
| Max bubbles | 500 | 150 | 3x less memory |
| Spawn logic | Date() allocations | Frame counter | No allocations |

**WornText Optimization**
- Created `CharStyle` struct for deterministic pseudo-random values
- Styles computed once per character index using hash-based seed
- Values stable across redraws (no random() calls in view body)

```swift
private struct CharStyle {
    init(index: Int, seed: Int) {
        let hash = (index * 31 + seed) & 0x7FFFFFFF
        inkDensity = 0.45 + Double((hash % 40)) / 100.0
        // ... deterministic from hash
    }
}
```

### v1.4 - Architecture & Accessibility (February 28, 2026)
**Focus: Code organization, accessibility, and Instagram sharing**

#### Design Token Extraction
Moved all design system tokens to `DesignTokens.swift`:
- Color tokens (brand, background, accents)
- PolaStrings (all text constants, localization-ready)
- PolaLayout (spacing, sizing, responsive values)
- Font extensions (polaTitle, polaBody, polaBodyBold)
- CharStyle struct (for WornText determinism)

Benefits:
- Single source of truth for design values
- Easier theming and customization
- Cleaner ContentView.swift (~200 lines removed)
- Better separation of concerns

#### Instagram Sharing (Initial)
Implemented via UIActivityViewController:
```swift
let activityVC = UIActivityViewController(
    activityItems: [uiImage],
    applicationActivities: nil
)
// Present from topmost view controller
topVC.present(activityVC, animated: true)
```

*Note: This was later replaced with direct Instagram Stories integration in v1.5*

#### VoiceOver Accessibility
Added comprehensive accessibility support:

| Component | Label | Hint |
|-----------|-------|------|
| SplashScreen | "polaGram splash screen" | "swipe or tap to dismiss" |
| PolaHeader | "polaGram, share what matters" | - |
| PlaceholderView | "tap to add photo" | "double tap to select or capture" |
| Clear button | "clear photo" | "double tap to remove and start over" |
| ActionMenu | "Share options" | - |
| ActionButton | (varies) | .isButton trait |

#### Unit Tests
Created `CharStyleTests.swift` with comprehensive coverage:
- Determinism verification (same inputs = same outputs)
- Variation tests (different indices/seeds produce variation)
- Bounds validation (all values within expected ranges)
- Stuck key rate (~12.5% verification)
- Edge cases (zero, negative, large values)
- Performance benchmarks

---

### v1.5 - Instagram Stories & Build Fix (March 1, 2026)
**Focus: Direct Instagram Stories sharing, build system fix, code audit**

#### Instagram Stories Integration
Replaced UIActivityViewController with direct Instagram Stories URL scheme:

**Problem**: Instagram button was opening generic iOS share sheet instead of Stories
**Solution**: Use Instagram's official URL scheme + pasteboard API

```swift
// 1. Build URL with source app identifier
let url = URL(string: "instagram-stories://share?source_application=mediaBrilliance.polaGram")!

// 2. Render pola to PNG (required for sticker support)
let imageData = uiImage.pngData()

// 3. Place on pasteboard with Instagram-specific keys
let pasteboardItems: [String: Any] = [
    "com.instagram.sharedSticker.stickerImage": imageData,
    "com.instagram.sharedSticker.backgroundTopColor": "#1A1A1A",
    "com.instagram.sharedSticker.backgroundBottomColor": "#4A3030"
]
UIPasteboard.general.setItems([pasteboardItems], options: [
    .expirationDate: Date().addingTimeInterval(300)  // 5 min expiry
])

// 4. Open Instagram Stories
UIApplication.shared.open(url)
```

**Info.plist Requirements**:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>instagram-stories</string>
    <string>instagram</string>
</array>
```

#### Build System Fix
**Problem**: "Multiple commands produce Info.plist" error

**Cause**: When switching from `GENERATE_INFOPLIST_FILE = YES` to using a custom
Info.plist, Xcode's new file synchronization feature (PBXFileSystemSynchronizedRootGroup)
was copying Info.plist to bundle resources AND the INFOPLIST_FILE setting was
processing it - two commands producing the same output.

**Solution**: Added `PBXFileSystemSynchronizedBuildFileExceptionSet` to exclude
Info.plist from the synchronized file copy:

```
// project.pbxproj
E7D801882F37E1A900357E79 /* PBXFileSystemSynchronizedBuildFileExceptionSet */ = {
    isa = PBXFileSystemSynchronizedBuildFileExceptionSet;
    membershipExceptions = (
        Info.plist,
    );
    target = E7D801792F37E1A800357E79 /* polaGram */;
};

E7D8017C2F37E1A800357E79 /* polaGram */ = {
    isa = PBXFileSystemSynchronizedRootGroup;
    exceptions = (
        E7D801882F37E1A900357E79,  // Reference to exception set
    );
    // ...
};
```

This is a new Xcode 16+ consideration when using file system synchronization
with custom Info.plist files.

#### "Shake It" Development Hint
Improved the UX hint during photo development:

**Before**: Small "shake to develop faster" text at bottom of caption area
**After**: Centered "shake it" overlay in photo frame area

Implementation:
- Noteworthy-Bold font at 28pt (matches handwritten aesthetic)
- Black text at 15% base opacity (subtle but visible on white)
- Fades out in sync with photo reveal: `opacity = 0.15 * (1.0 - developmentProgress)`
- Positioned as overlay on photo area, not caption area

#### Code Audit & Documentation
Comprehensive review of all code:

**ContentView.swift**:
- Added detailed MARK section comments
- Documented all state variables with purpose
- Added view hierarchy diagram in header
- Explained platform support matrix
- Documented shake detection physics
- Added Instagram pasteboard key documentation

**DesignTokens.swift**:
- Added color hex values and RGB breakdowns
- Documented font choices and when to use each
- Explained CharStyle hash algorithm
- Added property tables for quick reference
- Documented responsive scaling system

**Optimizations**:
- Simplified ShakeDetector shake handling guard clause
- Improved ChampagneBubbles spawn rate guard logic
- No functional changes, code clarity improvements only

---

### v1.6 - Vintage Filters (March 1, 2026)
**Focus: 50 vintage/worn photo filter effects**

#### Filter System Overview
Added authentic aging and wear effects to make polas look lived-in and nostalgic.
Each photo has a 50% chance of being pristine, 50% chance of getting a random effect.

```swift
// In startPhotoDevelopment():
activeFilter = PolaFilter.randomFilter()

// randomFilter() implementation:
static func randomFilter() -> PolaFilter? {
    guard Bool.random() else { return nil }  // 50% pristine
    return Self.allCases.randomElement()      // 50% random filter
}
```

#### Filter Categories (50 total)

| Category | Count | Examples |
|----------|-------|----------|
| Coffee Stains | 10 | Ring marks, spills, drips |
| Burn/Heat | 8 | Edge burns, cigarette holes, heat warp |
| Folds & Creases | 8 | Horizontal/vertical folds, dog ears |
| Water Damage | 6 | Stains, ripples, rain drops |
| Age & Sun | 8 | Yellowing, fading, scratches |
| Physical Damage | 6 | Torn edges, peeling, scrapes |
| Light & Exposure | 4 | Light leaks, overexposure |

#### PolaFilterOverlay Implementation
Renders effects using SwiftUI overlays, gradients, shapes, and blend modes:

```swift
struct PolaFilterOverlay: View {
    let filter: PolaFilter?
    let scale: CGFloat

    var body: some View {
        GeometryReader { geo in
            if let filter = filter {
                filterContent(for: filter, in: geo.size)
            }
        }
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private func filterContent(for filter: PolaFilter, in size: CGSize) -> some View {
        switch filter {
        case .coffeeRingTopLeft:
            coffeeRing(at: CGPoint(x: size.width * 0.15, y: size.height * 0.15), size: size)
        // ... 50 filter cases
        }
    }
}
```

#### Filter Effect Techniques
- **Coffee stains**: Ellipse strokes with AngularGradient for uneven ink, drips and splash dots
- **Burns**: Layered gradients with black → orange → clear, ember glow, ash specks
- **Folds**: Linear gradient shadows with white highlight lines
- **Water damage**: Ellipses with bluish RadialGradient, blur
- **Age effects**: Full-frame color overlays with low opacity
- **Light leaks**: RadialGradient with screen blend mode

#### Design Philosophy: Organic & Edge-Focused
Effects are designed to feel authentic, not digital:
- **Imperfect shapes**: Ellipses instead of circles, irregular rotation
- **Edge positioning**: Most effects start off-frame and creep onto the border
  - Coffee rings: `CGPoint(x: -size.width * 0.1, y: size.height * 0.4)` (mostly off-frame)
  - Burns: Positioned at corners and edges, not centered
- **Organic details**: Drips, splash dots, ash specks, ember glows
- **Gradient fading**: Effects fade naturally into the photo with RadialGradient
- **Multiply blend mode**: Effects darken like real stains, not opaque overlays

Example coffee ring implementation:
```swift
// Main ring - slightly elliptical for imperfection
Ellipse()
    .stroke(
        AngularGradient(  // Uneven ink density around ring
            colors: [coffeeColor.opacity(0.5), coffeeColor.opacity(0.3), ...],
            center: .center
        ),
        lineWidth: 10
    )
    .frame(width: radius * 2, height: radius * 2.1)  // Not perfectly circular
    .rotationEffect(.degrees(12))  // Slight tilt

// Drips running down from ring
Ellipse()
    .fill(LinearGradient(...))  // Fades from dark to transparent
    .frame(width: 12, height: 35)
    .offset(x: radius * 0.6, y: radius * 1.1)
```

#### Integration Points
1. **State variable**: `@State private var activeFilter: PolaFilter? = nil`
2. **Photo load**: `activeFilter = PolaFilter.randomFilter()` in `startPhotoDevelopment()`
3. **Clear photo**: `activeFilter = nil` in `clearPhoto()`
4. **PolaFrame**: Filter overlay applied to photo area
5. **StaticPolaFrame**: Same filter passed for saving/sharing

### v1.7 - Enhanced Filters & Fade-In (March 1, 2026)
**Focus: Realistic fold/crease effects and post-development reveal**

#### Filter Fade-In Animation
Vintage effects now fade in after photo development completes, creating a reveal effect where damage "ages" onto the pola:

```swift
// PolaFilterOverlay now accepts opacity parameter
struct PolaFilterOverlay: View {
    let filter: PolaFilter?
    let scale: CGFloat
    var opacity: Double = 1.0  // New parameter

    var body: some View {
        GeometryReader { geo in ... }
        .opacity(opacity)  // Applied to entire overlay
    }
}

// PolaFrame manages fade-in state
@State private var filterOpacity: Double = 0.0

.onChange(of: isDeveloping) { wasDeveloping, isNowDeveloping in
    if wasDeveloping && !isNowDeveloping {
        // Development finished - fade in filter over 1.5s
        withAnimation(.easeIn(duration: 1.5)) {
            filterOpacity = 1.0
        }
    } else if !wasDeveloping && isNowDeveloping {
        // New photo - reset
        filterOpacity = 0.0
    }
}
```

#### Enhanced Fold & Crease Effects
Improved realism for paper damage effects using layered shadow/highlight pairs:

**Dog Ear** - Now shows realistic folded corner curl:
- Curved shadow cast onto photo surface
- Gradient-filled fold showing paper curl (light → dark → light)
- Highlight along curved edge where light catches
- Crease lines at fold intersection

**Wrinkled Paper** - Each wrinkle now has 3D depth:
- Shadow side (below ridge) with tapered gradient
- Highlight side (above ridge) simulating light reflection
- Diagonal micro-creases for additional texture
- Variable depth and width for organic feel

**Bent Corner** - Subtle upward curl effect:
- Radial gradient shadow from lifted corner
- Curved crease line where bend occurs
- Edge highlight on raised portion

**Horizontal/Vertical Folds** - Enhanced ridge appearance:
- Multi-stop gradient shadows that taper naturally
- Sharp crease line at fold point
- Gradient highlights above the ridge

**Diagonal Fold** - Proper 3D treatment:
- Perpendicular offset calculation for accurate shadow/highlight placement
- Distinct shadow side, crease line, and highlight side

**Corner Fold** - Triangular fold with depth:
- Radial gradient shadow cast by fold
- Gradient fill with proper depth variation
- Crease line and edge highlight

#### Effect Technique: Shadow + Highlight Pairs
All fold/crease effects now use the same layering technique as coffee stains and burns:

```swift
// Example: Horizontal fold with 3D ridge
ZStack {
    // Shadow below fold (paper catching shadow)
    Rectangle()
        .fill(LinearGradient(
            colors: [.clear, creaseColor.opacity(0.3), creaseColor, creaseColor.opacity(0.5), .clear],
            startPoint: .top, endPoint: .bottom
        ))
        .frame(height: 12 * scale)

    // Sharp crease line
    Rectangle()
        .fill(creaseColor.opacity(opacity * 1.2))
        .frame(height: 1.5 * scale)

    // Highlight above (light catching ridge)
    Rectangle()
        .fill(LinearGradient(
            colors: [.clear, .white.opacity(0.4), .white.opacity(0.6), .clear],
            startPoint: .top, endPoint: .bottom
        ))
        .frame(height: 6 * scale)
}
```

### v1.8 - Realistic Frame Texture (March 1, 2026)
**Focus: Authentic matte photo paper appearance**

#### PolaFrameTexture Component
New overlay that adds multiple subtle effects to simulate real pola frame material:

| Layer | Effect | Implementation |
|-------|--------|----------------|
| 1 | Color variation | RadialGradient with warm center, breaks up flat white |
| 2 | Edge wear | Vignette darkening at edges from handling |
| 3 | Paper fiber | Canvas-drawn noise pattern (deterministic grid) |
| 4 | Micro-scratches | Pre-defined scratch paths with low opacity |
| 5 | Edge highlights | Subtle bottom/right highlights for thickness |
| 6 | Embossed border | Bottom/right highlights around photo cutout |

> **Note**: Top/left shadows were removed as they created visible lines across the frame. The texture now relies solely on subtle highlights which blend naturally with the white frame.

```swift
struct PolaFrameTexture: View {
    let scale: CGFloat
    let photoAreaSize: CGSize
    let photoAreaOffset: CGPoint

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Layer 1: Warm center gradient
                RadialGradient(colors: [warmWhite.opacity(0.4), .clear], ...)

                // Layer 2: Edge wear vignette
                Rectangle().fill(RadialGradient(
                    colors: [.clear, .clear, wearColor.opacity(0.04), wearColor.opacity(0.08)],
                    ...
                ))

                // Layer 3: Paper fiber (Canvas noise)
                Canvas { context, size in
                    // Deterministic grid-based noise pattern
                    for row in 0..<rows {
                        for col in 0..<cols {
                            let hash = (row * 31 + col * 17) & 0xFF
                            let opacity = Double(hash) / 255.0 * 0.025
                            context.fill(Path(ellipseIn: rect), with: .color(.black.opacity(opacity)))
                        }
                    }
                }
                .blendMode(.multiply)

                // Layer 4: Micro-scratches
                Canvas { context, size in
                    // Pre-defined scratch positions
                }

                // Layer 5: Edge shadows/highlights for thickness
                // Layer 6: Embossed photo border
            }
        }
    }
}
```

#### Design Principles
- **Subtlety**: Effects are barely perceptible individually but combine for authenticity
- **Determinism**: No random() calls - Canvas uses hash-based positioning
- **Performance**: Single Canvas pass for noise, pre-computed scratch paths
- **Consistency**: Same texture applied to both PolaFrame and StaticPolaFrame

#### Integration
Replaced simple black texture overlay with full PolaFrameTexture:
```swift
// Before
Color.polaFrameBackground.overlay(
    Rectangle().fill(Color.black.opacity(0.02)).blendMode(.multiply)
)

// After
Color.polaFrameBackground.overlay(
    PolaFrameTexture(scale: scale, photoAreaSize: photoSize, photoAreaOffset: offset)
)
```

---

## Technical Notes

### Photo Development System
The development animation simulates real instant film:
1. Photo loads with white overlay (developmentProgress = 0)
2. Timer increments progress every 100ms (0.5% per tick)
3. White opacity = 1.0 - developmentProgress
4. Full development takes 20 seconds passively
5. Shaking accelerates: each shake adds up to 5% progress
6. Haptic feedback on shake (intensity-based) and completion

### ImageRenderer Usage
`StaticPolaFrame` exists specifically for ImageRenderer:
- No drop shadows (real polas are flat prints)
- No interactive elements (no bindings, no callbacks)
- Photo area uses frame background color (avoids shadow-like contrast)
- Renders at 2x scale for high quality JPEG output

### Instagram Stories Integration (v1.5)
Uses official Instagram URL scheme + pasteboard API:
1. Check `canOpenURL` for `instagram-stories://` (requires Info.plist entry)
2. Render pola to PNG (required for sticker transparency)
3. Place on pasteboard with keys:
   - `com.instagram.sharedSticker.stickerImage` (PNG data)
   - `com.instagram.sharedSticker.backgroundTopColor` (hex)
   - `com.instagram.sharedSticker.backgroundBottomColor` (hex)
4. Open URL - Instagram reads from pasteboard automatically
5. Set pasteboard expiration for privacy (5 minutes)

### Platform Differences
| Feature | iOS/iPadOS | macOS |
|---------|------------|-------|
| Camera | UIImagePickerController | Not available |
| Photo picker | PhotosUI (both) | PhotosUI (both) |
| Shake detection | CoreMotion | Not available |
| Save | PHPhotoLibrary | NSSavePanel |
| Share Messages | MFMessageComposeViewController | Not implemented |
| Share Instagram | URL scheme + pasteboard | Not available |
| Haptics | UIImpactFeedbackGenerator | Not available |

### Required Info.plist Entries
```xml
<!-- Privacy Usage Descriptions -->
<key>NSMotionUsageDescription</key>
<string>Shake to develop photos faster</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Save your polas to Photos</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Choose photos to share as polas</string>

<key>NSCameraUsageDescription</key>
<string>Take photos for your polas</string>

<!-- URL Scheme Queries (required for canOpenURL) -->
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>instagram-stories</string>
    <string>instagram</string>
</array>
```

### Xcode Project Configuration Notes
When using custom Info.plist with file system synchronization (Xcode 16+):
- Set `GENERATE_INFOPLIST_FILE = NO`
- Set `INFOPLIST_FILE = path/to/Info.plist`
- Add `PBXFileSystemSynchronizedBuildFileExceptionSet` to exclude Info.plist
  from copy bundle resources (prevents "multiple commands produce" error)

---

## Lessons Learned

### SwiftUI Sheet Timing
Using `sheet(isPresented:)` with dynamically generated content can crash if the content isn't ready when the sheet presents. The `sheet(item:)` pattern with an Identifiable wrapper guarantees the data exists before presentation.

### Deterministic Randomness
Random values in SwiftUI view bodies cause unnecessary redraws. For effects that need "random but stable" styling, use deterministic pseudo-random based on stable seeds (like character index + text hash).

### Timer Memory Management
Swift closures capture `self` strongly by default. In Timer callbacks, always use `[weak self]` to prevent retain cycles that leak memory.

*Note: ContentView is a struct, so [weak self] isn't valid there. Instead, we break the cycle by explicitly invalidating the timer in finishDevelopment() and clearPhoto().*

### Responsive Design
Calculate scale factor once at the root GeometryReader, then pass it down through the view hierarchy. Multiply all fixed layout values by this factor for consistent scaling.

### Xcode File System Synchronization (v1.5)
Xcode 16+ uses `PBXFileSystemSynchronizedRootGroup` to automatically include all files in a folder. When using a custom Info.plist:
1. This causes Info.plist to be copied to bundle resources
2. INFOPLIST_FILE setting also processes it
3. Result: "Multiple commands produce Info.plist" error
4. Fix: Add exception set to exclude Info.plist from sync copy

### Instagram Sharing (v1.5)
UIActivityViewController shows ALL share targets, not just Instagram. For direct Instagram Stories sharing:
- Use `instagram-stories://share` URL scheme
- Place image on pasteboard with specific keys
- Instagram reads from pasteboard automatically
- Requires `LSApplicationQueriesSchemes` in Info.plist for `canOpenURL` check

### Vintage Filters (v1.6)
50 filter effects that make polas look aged, worn, and lived-in:
- **50/50 chance**: Half the polas stay pristine, half get a random effect
- **Filter assignment**: `activeFilter = PolaFilter.randomFilter()` on photo load
- **Categories**: Coffee stains (10), burns (8), folds (8), water damage (6), age/sun (8), physical damage (6), light leaks (4)
- **Rendering**: PolaFilterOverlay uses SwiftUI overlays, gradients, shapes, and blend modes
- **Persistence**: Filter stays until photo is cleared; included in saved/shared images

---

## Future Roadmap

### Planned Features
- [x] Share to Instagram Stories (URL scheme) - v1.5
- [x] Vintage/worn photo filters - v1.6
- [ ] Enhanced animations (parallax, ripple effects)
- [ ] Local persistence (save captions/photos)
- [ ] Multiple pola styles/frames
- [ ] Video support (short clips -> animated polas)

### Technical Debt
- [x] Extract design tokens to separate file - v1.4 (DesignTokens.swift)
- [x] Add unit tests for CharStyle determinism - v1.4 (CharStyleTests.swift)
- [x] Profile memory usage on older devices - v1.4 (MemoryProfilingGuide.md)
- [x] Accessibility improvements (VoiceOver labels) - v1.4
- [x] Comprehensive code documentation - v1.5

---

## Build Information

- **Minimum iOS**: 16.0
- **Swift**: 5.9+
- **Xcode**: 16.0+ (uses file system synchronization)
- **Frameworks**: SwiftUI, PhotosUI, CoreMotion, MessageUI, Photos, AVFoundation

## Version Summary

| Version | Date | Focus |
|---------|------|-------|
| v1.0 | Feb 7, 2026 | Design freeze, core features |
| v1.1 | Feb 28, 2026 | Caption system, WornText effect |
| v1.2 | Feb 28, 2026 | UX polish, caption overlay |
| v1.3 | Feb 28, 2026 | Code audit, optimizations |
| v1.4 | Feb 28, 2026 | Design tokens, accessibility |
| v1.5 | Mar 1, 2026 | Instagram Stories, build fix |
| v1.6 | Mar 1, 2026 | 50 vintage/worn photo filters |
