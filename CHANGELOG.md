# polaGram Changelog

## v2.4 - Caption Polish & App Store Ready (March 9, 2026)

### Caption Area Enhancement
- **Sharpie icon indicator**: Prominent writing icon in caption placeholder
  - 80% of caption height, responsive to frame size
  - Right-aligned with -12° tilt for character
  - 80% opacity for visibility
  - Caption text stays perfectly centered with balanced padding

### App Store Submission
- **APP_STORE_METADATA.md**: Complete metadata ready to paste
  - App name, subtitle (23 chars), description (1,847 chars)
  - Keywords (97 chars), What's New text
  - Age rating questionnaire answers
- **APP_STORE_SUBMISSION.md**: Step-by-step submission guide
  - Screenshot requirements and capture instructions
  - App Store Connect setup walkthrough
  - Review notes template
  - Common rejection reasons to avoid

### Project Updates
- Version bumped to 2.3 in Xcode project
- Website updated with stacking effects feature
- Privacy policy and terms of service current

---

## v2.3 - Stacked Filter Effects (March 9, 2026)

### Filter System Overhaul
- **Stacking probability system** for vintage effects:
  - 20% pristine (no effects)
  - 40% get 1 effect
  - 20% get 2 effects
  - 10% get 3 effects
  - 5% get 4 effects
  - 4% get 5 effects
  - 1% "mangled" (angry ex treatment - crumpled, burned, stained chaos)

### The "Mangled" Treatment
- Rare 1% chance for extreme damage stack:
  - Multiple burn marks (cigarette, match, edge burns)
  - Crumpled with many folds and creases
  - Coffee/water damage stains
  - Heavy aging, scratches, and wear
  - Random light leaks and chemical damage
  - Image still visible through the chaos

### Technical Changes
- `PolaFilter.randomFilters()` returns `[PolaFilter]` array
- `PolaFilterOverlay` now stacks multiple effects in ZStack
- `SavedPola` model updated for multi-filter storage
- Backwards-compatible with legacy single-filter code

---

## v2.1 - Branding Update (March 1, 2026)

### Trademark Compliance
- **Removed all "Polaroid" references** from the entire app
  - Replaced with "pola", "pic", or "instant" as appropriate
  - Updated Info.plist permission descriptions
  - Updated onboarding tutorial text
  - Updated code comments and documentation

### UI Refinement
- **Watermark toggle simplified**: Removed visual indicator badge from save button
  - Long-press save button still toggles watermark on/off
  - Brief text feedback shows "Watermark ON/OFF" when toggled

---

## v2.0 - Professional Features (March 1, 2026)

### Sound Effects
- **SoundManager**: Centralized audio feedback using system sounds
  - Camera shutter click on photo capture
  - Subtle ticks during photo development (~every 2 seconds)
  - Confirmation sound when pola is saved
  - Coordinated haptic feedback with sounds

### Watermark Toggle
- **Optional "polaGram" watermark** on saved/shared images
  - Long-press save button to toggle on/off
  - Setting persisted in UserDefaults
  - Watermark appears in bottom-left corner of photo

### Onboarding Tutorial
- **First-time user guide** with 4 tutorial steps:
  1. Capture: Tap the pola frame to take/select photo
  2. Develop: Watch photo develop, shake to speed up
  3. Caption: Tap to add handwritten caption
  4. Share: Save, message, or Instagram Stories
- Shows once, persisted via `hasSeenOnboarding` in UserDefaults
- Skip button and Next/Get Started navigation

### Widget Extension
- **Home screen widget** showing random saved pola
- Supports small and medium widget sizes
- Requires Xcode setup (Widget Extension target + App Groups)

### Testing
- **Unit tests**: CharStyle, PolaFilter, SavedPola, date formatting
- **UI tests**: Splash, onboarding, gallery, action buttons, accessibility

---

## v1.4 - Architecture & Accessibility (February 28, 2026)

### Code Architecture
- **DesignTokens.swift**: Extracted all design tokens to dedicated file
  - Color tokens (brand colors, backgrounds, accents)
  - PolaStrings (localization-ready text constants)
  - PolaLayout (spacing, sizing, responsive scaling)
  - Font extensions (custom typography helpers)
  - CharStyle struct (deterministic pseudo-random for WornText)

### Instagram Sharing
- **UIActivityViewController integration**: Share polas via system share sheet
  - Works with Instagram Stories, Feed, and all installed apps
  - No SDK required, respects user privacy
  - iPad popover support

### VoiceOver Accessibility
- **Comprehensive accessibility labels** added throughout:
  - SplashScreen: label and dismiss hint
  - PolaHeader: combined brand identity label
  - PlaceholderView: tap to add photo hint
  - Clear photo button: label and action hint
  - ActionMenu: share options container label
  - ActionButton: button traits and labels
  - CaptionArea: edit caption hint

### Unit Tests
- **CharStyleTests.swift**: Test suite for determinism verification
  - Same inputs produce same outputs
  - Different indices/seeds produce variation
  - Value bounds validation (ink density, tilt, spacing)
  - Stuck key rate verification (~12.5%)
  - Edge case handling (zero index, negative seed, large values)
  - Performance measurement

### Documentation
- **MemoryProfilingGuide.md**: Comprehensive memory profiling guide
  - Key areas to profile (bubbles, images, timers, shake detection)
  - Expected behaviors and baseline memory
  - Instruments commands and debug helpers
  - Red flags and recommended profiling sessions

---

## v1.3 - Code Audit & Optimization (February 28, 2026)

### Removed Dead Code
- **CaptionEditorView**: Removed 200+ lines of unused full-screen editor (replaced by CaptionEditorOverlay)
- **accelerateDevelopment()**: Removed unused function (shake handling is inline)
- **Duplicate imports**: Removed redundant UIKit import in iOS section

### Memory & Performance Fixes
- **Timer retain cycle**: Fixed `[self]` → `[weak self]` in development timer
- **ChampagneBubbles optimized**:
  - 100fps → 30fps (3x less CPU)
  - Max 500 → 150 bubbles (3x less memory)
  - Simplified spawn logic (removed Date() allocations)
- **WornText optimized**:
  - Created `CharStyle` struct for deterministic pseudo-random values
  - Styles computed once per character index, stable across redraws
  - No more random() calls in view body

### Documentation
- **ContentView.swift**: Comprehensive inline documentation added
  - File header with version history and architecture overview
  - Component hierarchy diagram
  - User flow documentation
  - MARK sections with detailed comments
  - Method documentation with usage notes
- **devLog.md**: Created development log with:
  - Architecture overview
  - Version history with technical details
  - Bug fix explanations with code examples
  - Technical notes (development system, ImageRenderer, platform differences)
  - Lessons learned
  - Future roadmap

---

## v1.2 - UX Polish (February 28, 2026)

### Caption Editor Overlay
- **Overlay mode**: Caption editor now floats over the pola frame (visible beneath)
- Semi-transparent backdrop (tap to cancel)
- Centered Noteworthy-Bold input with responsive sizing
- Slide-up card with cancel/done buttons

### Photo Management
- **Clear photo button**: X button on photo to discard and start fresh
- Only visible when photo exists and not developing
- Resets photo, caption, and development state

### Message Share Fix
- Fixed first-tap crash using `sheet(item:)` pattern
- Image guaranteed ready before sheet presents

---

## v1.1 - Caption Update (February 28, 2026)

### Caption System Overhaul
- **Character limit**: 42 → 24 chars (authentic Sharpie-on-pola sizing)
- **WornText component**: Broken Hemingway typewriter aesthetic
  - Irregular letter spacing (some overlap at -8%, some gap at +3%)
  - Stuck keys (~12.5% of letters drop below baseline)
  - Worn ribbon effect (ink density varies 45-85% per character)
  - Misaligned typebars (±2.5° rotation per letter)
  - Carriage slip (subtle horizontal jitter)
- **Bold compensation**: Smaller text gets heavier treatment
  - Ink density increases (up to 70-100% at minimum size)
  - Blur decreases (sharper edges = fresh Sharpie look)
  - Shadow opacity increases
- **Vertical padding**: 12% top/bottom to prevent descender clipping (g, q, p, y)
- **Centering**: Caption stays centered despite per-character chaos

### Bug Fixes
- Fixed message share crash on first tap (SwiftUI sheet timing issue)
  - Changed from `sheet(isPresented:)` to `sheet(item:)` pattern
  - Image now guaranteed ready before sheet presents

---

## v1.0 - Design Freeze (February 7, 2026)

### Core Features
- Photo picker integration (PhotosUI framework)
- Camera capture (UIImagePickerController)
- Pola development effect with shake acceleration
- Haptic feedback (UIImpactFeedbackGenerator)
- Caption editor with modal popup
- Save to Photos (ImageRenderer + PHPhotoLibrary)

### Design System
- Token-based colors, typography, and layout constants
- Responsive scaling via GeometryReader (clamped min/max)
- Cross-platform support (iOS, iPadOS, macOS)

### Components
- PolaBackground: Animated gradient, vignette, champagne bubbles, film grain
- PolaHeader/PolaLogo: Brand presentation
- PolaFrame: Pola frame with photo area, caption, date stamp
- ActionMenu: Share buttons (message, instagram, save)
- SplashScreen: Launch overlay with dismiss gestures
- ShakeDetector: Accelerometer-based development acceleration
- CameraView: iOS camera capture interface
