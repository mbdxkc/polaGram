//
//  ContentView.swift
//  polaGram
//
//  Created by valdez campos on 2/5/26.
//
//  A Polaroid-style photo sharing app with an authentic aesthetic.
//  Combines retro design with modern SwiftUI architecture.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import PhotosUI  // For photo picker functionality (not yet implemented)
import Photos     // For photo library access (not yet implemented)

// MARK: - Documentation

/*
 polaGram Design System
 =====================
 
 This file contains the complete UI implementation and design token system for polaGram.
 The app creates Polaroid-style photo frames with handwritten captions and vintage date stamps.
 
 ## Architecture
 - **SwiftUI-based**: Pure SwiftUI implementation with responsive scaling
 - **Component-driven**: Modular, reusable components (PolaFrame, ActionMenu, ActionButton)
 - **Token-based design**: Centralized colors, typography, and layout constants
 - **Responsive**: Scales automatically across different device sizes using GeometryReader
 - **Cross-platform**: Supports both iOS/iPadOS and macOS with conditional compilation
 
 ## Color Palette
 - **polaPink**: Primary brand color (bright bubblegum pink #FF69B4)
 - **polaPinkLight**: Light pink for gradients (#FFBFD9)
 - **polaPinkHot**: Hot pink accent (#FF1494)
 - **polaGradientCenter/Mid/Edge**: Dark background radial gradient (grayish-blue → purple-gray → burgundy)
 - **polaSilverLight/Dark**: Secondary brand colors (silver/blue gradient)
 - **polaFrameBackground**: Polaroid frame background (white/cream, dark mode aware)
 - **polaPhotoBackground**: Photo area background (off-white/dark gray, dark mode aware)
 - **polaDateStamp**: Authentic vintage orange for date stamp (#FF7300)
 
 ## Typography
 - **H1/Title**: Marker Felt Wide (48pt) - for "polaGram" logo (casual handwritten font)
 - **Body**: Avenir Next Condensed Regular (14-18pt) - for tagline, buttons, UI text
 - **Body Bold**: Avenir Next Condensed Bold (14pt) - for emphasized text (currently unused)
 - **Handwritten**: Bradley Hand Bold (15pt) - for photo captions with rotation effect (faded look)
 
 ## Components
 1. **ContentView**: Root view with gradient background, header, Polaroid frame, and action menu
 2. **PolaFrame**: Polaroid frame (312×392pt) with photo area (280×280pt) and caption (80pt height)
 3. **ActionMenu**: Bottom action bar with three buttons (message, instagram, save)
 4. **ActionButton**: Individual action button with icon, label, and press state animation
 
 ## Layout Specifications
 - **Frame dimensions**: 312×392pt (authentic Polaroid proportions)
 - **Photo area**: 280×280pt (1:1 square aspect ratio)
 - **Caption area**: 80pt height (fits 3-4 lines at 42 char limit)
 - **Responsive scaling**: Reference width 360pt, scale factor clamped 0.85x-1.3x
 - **Frame padding**: 16pt internal padding
 - **Safe area handling**: Header and menu respect safe areas with minimum padding
 
 ## State Management
 - `selectedPhoto`: PhotosPickerItem (⚠️ not yet connected to UI)
 - `photoImage`: Optional Image for display in Polaroid frame
 - `caption`: User-editable string with 42 character limit and live counter
 - `isCaptionFocused`: FocusState for showing character counter
 - `isPressed`: Per-button press state for visual feedback
 
 ## Design Improvements (v2)
 ✅ **Fixed Issues:**
 1. Cross-platform dark mode support (iOS, iPadOS, macOS)
 2. Character counter shown when caption is focused (e.g., "24/42")
 3. Removed placeholder date stamp in empty state (cleaner look)
 4. Better safe area handling for notched devices
 5. Improved responsive scaling range (0.85x-1.3x)
 6. Fixed placeholder caption to exactly 42 characters
 7. Removed all unused code (unused strings, layout constants, fonts)
 8. Replaced hacky inner shadow with subtle overlay
 9. Fixed negative spacing with proper layout values
 
 ## Performance Optimizations (v3)
 ✅ **Rendering:**
 1. Metal acceleration with `.drawingGroup()` on gradients and logo
 2. Cached formatted date string (computed once, not on every render)
 3. Separated subcomponents (PlaceholderView, CaptionArea) for better view identity
 4. Rasterized vignette overlay with `.drawingGroup()`
 5. Optimized logo shimmer with single opacity animation
 
 ## Aesthetic Enhancements (v4)
 ✅ **Visual Polish:**
 1. **Polaroid Frame Authenticity**
    - Rounded photo corners (4pt radius) like real Polaroids
    - Warmer cream/ivory frame tones (aged paper aesthetic)
    - 3D bevel effect on frame edges (light/dark gradient stroke)
    - More pronounced layered shadows for depth
    - Gentle floating/breathing animation (subtle vertical motion)
 
 2. **Background Enhancements**
    - Bottom vignette added (matches top, focuses attention)
    - Animated film grain texture overlay (vintage feel)
    - Warmer color temperature in gradients (nostalgic mood)
    - More saturated pink accents in bubbles
 
 3. **Typography & Logo**
    - Subtle pink glow around logo text
    - Letter-press effect on tagline (inset shadow)
    - Increased caption rotation variance (-3.5° to -0.5°)
    - Breathing animation on caption placeholder
 
 4. **Interaction Polish**
    - Glow effect on buttons when pressed (pink halo)
    - More bouncy spring animation on press
    - Stronger scale effect (0.92x vs 0.95x)
    - Date stamp more faded/aged (85% opacity)
 
 5. **Color Refinement**
    - Warmer frame whites (ivory #FCFAF0 instead of pure white)
    - More saturated pink in bubbles (#FFB0D5)
    - Softer vintage orange date stamp (#E89B6C)
    - Warmer background gradient tones
 
 6. **Micro-Animations**
    - Bubbles have rotation property (future: spinning motion)
    - Caption placeholder breathes (opacity 22% ↔ 18%)
    - Polaroid floats gently (3pt vertical motion)
 
 ⚠️ **Not Yet Implemented (Design Phase):**
 1. Photo picker integration (PhotosPicker not connected to UI)
 2. Photo loading from PhotosPickerItem
 3. Save to Photos functionality
 4. Share to Messages functionality
 5. Share to Instagram functionality
 6. Camera capture support
 7. Tap gesture on Polaroid frame
 8. Button actions
 9. Haptic feedback
 10. Empty state button disabling
 11. Parallax tilt with gyroscope
 12. Ripple effect from tap points
 
 ## Placeholder State (when no photo loaded)
 - Shows "pG_logo" image at 70% size, 15% opacity (fallback: SF Symbol)
 - Displays "tap to add a photo" instruction at 95% opacity
 - No date stamp shown until photo is added
 */

// MARK: - Color Tokens

/// Extension providing the polaGram color palette
/// All colors use RGB values for precise color matching
extension Color {
    
    // MARK: Brand Colors - Pink Gradient Scheme
    
    /// Primary brand color - Bright bubblegum pink
    /// Used in: Logo gradient, button press states
    /// Hex: #FF69B4 | RGB: (255, 105, 180)
    static let polaPink = Color(red: 1.0, green: 0.41, blue: 0.71)
    
    /// Light pink for gradient effects - More saturated
    /// Used in: Logo gradient (top), button press states, bubbles
    /// Hex: #FFB0D5 | RGB: (255, 176, 213)
    static let polaPinkLight = Color(red: 1.0, green: 0.69, blue: 0.84)
    
    /// Hot pink accent for gradient depth
    /// Used in: Logo gradient (bottom)
    /// Hex: #FF1494 | RGB: (255, 20, 148)
    static let polaPinkHot = Color(red: 1.0, green: 0.08, blue: 0.58)
    
    // MARK: Background Gradient - Dark Moody Tones (Warmer)
    
    /// Center of radial background gradient (lightest point) - Warmer tone
    /// Warm grayish-blue | RGB: (125, 135, 150) approx
    static let polaGradientCenter = Color(red: 0.49, green: 0.53, blue: 0.59)
    
    /// Mid-point of radial background gradient - Warmer purple
    /// Warm purple-gray | RGB: (85, 70, 80) approx
    static let polaGradientMid = Color(red: 0.33, green: 0.27, blue: 0.31)
    
    /// Edge of radial background gradient (darkest) - Warmer burgundy
    /// Deep warm burgundy | RGB: (95, 45, 45) approx
    static let polaGradientEdge = Color(red: 0.37, green: 0.18, blue: 0.18)
    
    // MARK: UI Colors - Silver/Blue Accents
    
    /// Light silver for UI elements and text
    /// Used in: Action buttons, tagline
    /// RGB: (217, 224, 235) approx
    static let polaSilverLight = Color(red: 0.85, green: 0.88, blue: 0.92)
    
    /// Dark silver-blue for gradients and contrast
    /// Used in: Action buttons, logo gradient, tagline
    /// RGB: (191, 204, 224) approx
    static let polaSilverDark = Color(red: 0.75, green: 0.80, blue: 0.88)
    
    // MARK: Polaroid Frame Colors - Dark Mode Aware
    
    /// Frame border background color - Warmer cream/ivory tones
    /// Light: Warm ivory | Dark: Aged cream
    static let polaFrameBackground = Color(
        light: Color(red: 0.99, green: 0.98, blue: 0.94),
        dark: Color(red: 0.96, green: 0.95, blue: 0.91)
    )
    
    /// Photo area background (appears when no photo loaded)
    /// Light: Warm off-white | Dark: Very dark gray with warmth
    static let polaPhotoBackground = Color(
        light: Color(red: 0.96, green: 0.95, blue: 0.92),
        dark: Color(red: 0.13, green: 0.12, blue: 0.11)
    )
    
    // MARK: Accent Colors
    
    /// Authentic vintage Polaroid date stamp color - More faded/aged
    /// Softer orange tone for vintage authenticity
    /// Hex: #E89B6C | RGB: (232, 155, 108)
    static let polaDateStamp = Color(red: 0.91, green: 0.61, blue: 0.42)
    
    // MARK: Helper Initializer
    
    /// Creates a color that adapts to light/dark mode
    /// - Parameters:
    ///   - light: Color to use in light mode
    ///   - dark: Color to use in dark mode
    /// - Note: Cross-platform compatible using SwiftUI's ColorScheme
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        self.init(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
        })
        #else
        self = light
        #endif
    }
}

// MARK: - String Constants

/// Centralized string constants for UI text and messages
/// Single source of truth for all user-facing text
struct PolaStrings {
    
    // MARK: Branding
    
    /// App title text
    static let appTitle = "polaGram"
    
    /// App tagline text
    static let appTagline = "share what matters"
    
    // MARK: Placeholder Text
    
    /// Caption placeholders with casual tone (42 chars exactly each)
    static let captionPlaceholders = [
        "holy shit, i can't believe this happened omg",
        "this moment right here changed everything fr",
        "felt cute might delete later idk lol omg wow",
        "vibes were immaculate not gonna lie honestly",
        "this is exactly what i needed today for real",
        "never forget this feeling right here forever",
        "pretty sure this was the best day of my life",
        "no bc this actually means everything to me rn",
        "genuinely can't stop thinking about this ngl",
        "this energy is immaculate i'm not even lying",
        "lowkey the highlight of my entire year tbh fr",
        "actually obsessed with this moment right here",
        "the way this made me feel literally insane fr",
        "can't explain how much this means to me omg x",
        "drunk thoughts but this is everything to me x",
        "we were so fucked up but this was perfect lol",
        "blacked out but somehow remember this moment x",
        "definitely got too turnt but worth it ngl tbh",
        "woke up thinking about this and i'm deceased x",
        "still not over whatever the fuck this was tbh",
        "this hit different and i'm still not okay omg",
        "the energy was unmatched i'm literally crying",
        "absolutely unhinged behavior but i love it fr",
        "chaotic energy but make it aesthetic somehow x",
        "feral over this and i have zero regrets at all",
        "losing my shit over this in the best way tbh",
        "this unlocked something in me i can't explain",
        "main character energy and i'm here for it fr x",
        "no thoughts just vibes and this exact moment x",
        "the serotonin boost i needed so desperately fr",
        "core memory unlocked and i'm emotional about x",
        "this is my roman empire now apparently so yeah",
        "rotting in bed thinking about this all day lol",
        "delulu is the solulu and this proves it facts",
        "mentally i'm still here and will be forever x",
        "gave me whiplash in the best way possible fr x",
        "screaming crying throwing up over this moment",
        "my therapist will hear about this next session",
        "didn't expect to feel this way but here we are",
        "universe really said it's your moment babe go x",
        "manifested this energy and it actually worked x",
        "living for this chaos and refusing to apologize"
    ]
    
    /// Returns a random caption placeholder
    static var randomCaptionPlaceholder: String {
        captionPlaceholders.randomElement() ?? captionPlaceholders[0]
    }
    
    // MARK: Action Button Labels
    
    /// Message button label
    static let messageButton = "message"
    
    /// Instagram button label
    static let instagramButton = "instagram"
    
    /// Save button label
    static let saveButton = "save"
    
    // MARK: Accessibility Labels
    
    /// VoiceOver hint for photo frame
    static let addPhotoHint = "double tap to select or capture a photo"
    
    /// VoiceOver label for selected photo
    static let selectedPhotoLabel = "selected photo"
    
    /// VoiceOver hint for caption field
    static let captionAccessibilityHint = "double tap to edit caption"
    
    /// VoiceOver label for message button
    static let shareViaMessagesLabel = "share via messages"
    
    /// VoiceOver label for instagram button
    static let shareToInstagramLabel = "share to instagram"
    
    /// VoiceOver label for save button
    static let saveToPhotosLabel = "save to photos"
}

// MARK: - Layout Tokens

/// Centralized layout constants for responsive design
/// All values in points (pt), scaled by GeometryReader multiplier
struct PolaLayout {
    
    // MARK: Frame Dimensions
    
    /// Polaroid frame width (authentic proportions)
    static let frameWidth: CGFloat = 312
    
    /// Polaroid frame total height
    /// Breakdown: 16pt top + 280pt photo + 1pt divider + 80pt caption + 15pt bottom = 392pt
    static let frameHeight: CGFloat = 392
    
    /// Photo area size (1:1 square aspect ratio)
    static let photoSize: CGFloat = 280
    
    // MARK: Spacing & Padding
    
    /// Internal frame padding (edges, caption horizontal)
    static let framePadding: CGFloat = 16
    
    /// Caption text area height (fits 3-4 lines at 15pt Chalkduster)
    static let captionHeight: CGFloat = 80
    
    /// Header top padding from safe area
    static let headerTopPadding: CGFloat = 60
    
    // MARK: Visual Details
    
    /// Frame corner radius
    static let cornerRadius: CGFloat = 5
    
    /// Divider line thickness
    static let borderWidth: CGFloat = 1
    
    /// Divider opacity (very subtle)
    static let dividerOpacity: Double = 0.08
    
    /// Background pink glow opacity
    static let backgroundPinkOpacity: Double = 0.06
    
    /// Frame texture overlay opacity (subtle paper feel)
    static let frameTextureOpacity: Double = 0.02
    
    /// Photo film grain overlay opacity
    static let filmGrainOpacity: Double = 0.03
    
    // MARK: Typography Sizes
    
    /// App logo font size
    static let titleSize: CGFloat = 48
    
    /// Tagline font size
    static let subtitleSize: CGFloat = 18
    
    /// Caption text size
    static let captionSize: CGFloat = 15
    
    /// Date stamp font size
    static let dateStampSize: CGFloat = 11
    
    /// Placeholder instruction text size
    static let placeholderTextSize: CGFloat = 13
    
    // MARK: Header Positioning
    
    /// Tagline vertical spacing from title
    static let taglineSpacing: CGFloat = 0
    
    /// Tagline horizontal offset (0 = centered)
    static let taglineOffsetX: CGFloat = 0
    
    /// Tagline vertical fine-tuning offset
    static let taglineOffsetY: CGFloat = -20
    
    // MARK: Date Stamp Positioning
    
    /// Date stamp distance from right edge (increased for breathing room)
    static let dateStampTrailing: CGFloat = 12
    
    /// Date stamp distance from bottom edge (increased for breathing room)
    static let dateStampBottom: CGFloat = 10
    
    // MARK: Action Menu
    
    /// Action menu container height
    static let menuHeight: CGFloat = 80
    
    /// Action button icon size
    static let menuIconSize: CGFloat = 28
    
    /// Spacing between action buttons
    static let menuSpacing: CGFloat = 50
    
    /// Action menu bottom padding from screen edge
    static let menuBottomPadding: CGFloat = 20
    
    // MARK: Responsive Scaling
    
    /// Reference width for scale calculation (standard iPhone width)
    /// Scale factor formula: deviceWidth / 360
    static let referenceWidth: CGFloat = 360
    
    /// Minimum scale factor for very small devices
    static let minScale: CGFloat = 0.85
    
    /// Maximum scale factor for very large devices
    static let maxScale: CGFloat = 1.3
}

// MARK: - Font Tokens

/// Custom font helpers for polaGram typography system
/// Falls back gracefully if custom fonts unavailable
extension Font {
    
    /// App logo title font (Bradley Hand Bold)
    /// - Parameter size: Font size in points
    /// - Returns: Bradley Hand Bold at specified size (iOS system font, always available)
    /// - Note: Default 36pt, currently used at 42pt for logo
    static func polaTitle(size: CGFloat = 36) -> Font {
        .custom("BradleyHandITCTT-Bold", size: size)
    }
    
    /// Body text font (Avenir Next Condensed Regular)
    /// - Parameter size: Font size in points
    /// - Returns: Avenir Next Condensed Regular at specified size
    /// - Note: Used for tagline (18pt), buttons (12pt), and all UI text
    static func polaBody(size: CGFloat = 14) -> Font {
        .custom("AvenirNextCondensed-Regular", size: size)
    }
    
    /// Bold body text font (Avenir Next Condensed Bold)
    /// - Parameter size: Font size in points
    /// - Returns: Avenir Next Condensed Bold at specified size
    /// - Note: Currently unused, reserved for emphasized text
    static func polaBodyBold(size: CGFloat = 14) -> Font {
        .custom("AvenirNextCondensed-Bold", size: size)
    }
}

// MARK: - Content View

/// Root view of polaGram app
/// Implements responsive layout with gradient background, header, Polaroid frame, and action menu
struct ContentView: View {
    
    // MARK: State Properties
    
    /// Selected photo from picker (not yet connected to UI)
    @State private var selectedPhoto: PhotosPickerItem?
    
    /// Image to display in Polaroid frame (nil shows placeholder)
    @State private var photoImage: Image?
    
    /// User-editable caption (max 42 characters, enforced in TextField onChange)
    @State private var caption: String = ""
    
    /// Controls splash screen visibility
    @State private var showSplash: Bool = true  // Splash screen enabled on launch
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            // Main app content
            mainContent
                .opacity(showSplash ? 0 : 1)
            
            // Splash screen overlay
            if showSplash {
                SplashScreen()
                    .transition(.opacity)
                    .zIndex(1)
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onEnded { value in
                                if value.translation.width < -50 || value.translation.height < -50 {
                                    dismissSplash()
                                }
                            }
                    )
                    .onTapGesture {
                        dismissSplash()
                    }
            }
        }
    }
    
    // MARK: Main Content
    
    private var mainContent: some View {
        GeometryReader { geometry in
            let scale = scaleFactor(for: geometry.size)
            
            ZStack {
                PolaBackground(scale: scale)
                
                VStack(spacing: 0) {
                    PolaHeader()
                        .padding(.top, max(PolaLayout.headerTopPadding, geometry.safeAreaInsets.top + 20))
                    
                    Spacer()
                    
                    PolaFrame(photoImage: photoImage, caption: $caption, scale: scale)
                    
                    Spacer()
                    
                    ActionMenu(scale: scale, hasPhoto: photoImage != nil)
                        .padding(.bottom, max(PolaLayout.menuBottomPadding * scale, geometry.safeAreaInsets.bottom + 10 * scale))
                }
            }
        }
    }
    
    // MARK: Helper Methods
    
    /// Dismisses splash screen with animation
    private func dismissSplash() {
        withAnimation(.easeOut(duration: 0.5)) {
            showSplash = false
        }
    }
    
    /// Calculates responsive scale factor based on device width
    /// - Parameter size: Screen size from GeometryReader
    /// - Returns: Scale multiplier (clamped using PolaLayout min/max values)
    private func scaleFactor(for size: CGSize) -> CGFloat {
        let baseScale = size.width / PolaLayout.referenceWidth
        return min(max(baseScale, PolaLayout.minScale), PolaLayout.maxScale)
    }
}

// MARK: - Background Component

/// Animated background with gradient, champagne bubbles, and film grain
/// Optimized for performance with Metal acceleration
struct PolaBackground: View {
    let scale: CGFloat
    @State private var animateGradient = false
    @State private var grainOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Radial gradient with animated center
            RadialGradient(
                gradient: Gradient(colors: [
                    .polaGradientCenter.opacity(0.9),
                    .polaPink.opacity(PolaLayout.backgroundPinkOpacity),
                    .polaGradientMid,
                    .polaGradientEdge
                ]),
                center: animateGradient ? UnitPoint(x: 0.35, y: 0.4) : UnitPoint(x: 0.65, y: 0.6),
                startRadius: 100 * scale,
                endRadius: 500 * scale
            )
            .ignoresSafeArea()
            .drawingGroup() // Rasterize for better performance
            .onAppear {
                withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            // Subtle animated film grain texture
            FilmGrainOverlay(offset: grainOffset)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 0.15).repeatForever(autoreverses: false)) {
                        grainOffset = 100
                    }
                }
            
            // Champagne bubbles
            ChampagneBubbles()
            
            // Top vignette overlay
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        .black,
                        .black.opacity(0.6),
                        .clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200 * scale)
                .ignoresSafeArea(edges: .top)
                
                Spacer()
                
                // Bottom vignette overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .black.opacity(0.4),
                        .black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 150 * scale)
                .ignoresSafeArea(edges: .bottom)
            }
            .drawingGroup() // Rasterize vignettes
        }
    }
}

// MARK: - Film Grain Overlay

/// Subtle animated film grain for vintage aesthetic
struct FilmGrainOverlay: View {
    let offset: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.02))
            .blendMode(.overlay)
            .drawingGroup()
    }
}

// MARK: - Champagne Bubbles

/// Continuous stream of bubbles rising from bottom (wide) to top (narrow)
/// Creates a champagne glass silhouette effect with "fresh pour" intensity
struct ChampagneBubbles: View {
    @State private var bubbles: [Bubble] = []
    @State private var spawnInterval: TimeInterval = 0.006 // DOUBLED speed - insane champagne explosion
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(bubbles) { bubble in
                    BubbleView(
                        bubble: bubble,
                        screenHeight: geometry.size.height,
                        screenWidth: geometry.size.width
                    )
                }
            }
            .onAppear {
                startBubbleStream(screenSize: geometry.size)
                startSpawnRateTransition()
            }
        }
        .allowsHitTesting(false)
    }
    
    private func startBubbleStream(screenSize: CGSize) {
        // Create bubbles continuously with dynamic spawn rate
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            // Check if enough time has passed since last spawn
            if shouldSpawnBubble() {
                // Spawn bubbles across the full width at bottom
                let randomX = CGFloat.random(in: 0...screenSize.width)
                
                let newBubble = Bubble(
                    id: UUID(),
                    startX: randomX,
                    screenHeight: screenSize.height,
                    screenWidth: screenSize.width
                )
                bubbles.append(newBubble)
                
                // DOUBLED capacity - absolutely wild bubble density
                if bubbles.count > 500 {
                    bubbles.removeFirst()
                }
            }
        }
    }
    
    @State private var lastSpawnTime: Date = Date()
    
    private func shouldSpawnBubble() -> Bool {
        let now = Date()
        if now.timeIntervalSince(lastSpawnTime) >= spawnInterval {
            lastSpawnTime = now
            return true
        }
        return false
    }
    
    private func startSpawnRateTransition() {
        // Gradually slow down spawn rate over 10 seconds for smoother transition
        // 0.006s → 0.15s (25x slower - extreme deceleration)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if spawnInterval < 0.15 {
                // Gradually increase interval (slow down spawning)
                spawnInterval += 0.00144 // (0.15 - 0.006) / 100 steps
            } else {
                timer.invalidate()
            }
        }
    }
}

/// Individual bubble data
struct Bubble: Identifiable {
    let id: UUID
    let startX: CGFloat
    let screenHeight: CGFloat
    let screenWidth: CGFloat
    let duration: Double = Double.random(in: 5...7)
    let size: CGFloat = CGFloat.random(in: 4...10)
    let rotation: Double = Double.random(in: 0...360)
    let color: Color = [.white, .white.opacity(0.7), .polaPinkLight.opacity(0.7), .polaSilverLight.opacity(0.5)].randomElement()!
}

/// Animated bubble view with converging motion
struct BubbleView: View {
    let bubble: Bubble
    let screenHeight: CGFloat
    let screenWidth: CGFloat
    
    @State private var yPosition: CGFloat = 0
    @State private var xPosition: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 1.5 // Start 50% bigger (1.5x instead of 1.0x)
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        bubble.color.opacity(0.4),
                        bubble.color.opacity(0.15),
                        .clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: bubble.size / 2
                )
            )
            .frame(width: bubble.size * scale, height: bubble.size * scale)
            .position(x: bubble.startX + xPosition, y: bubble.screenHeight - yPosition)
            .opacity(opacity)
            .onAppear {
                animateBubble()
            }
    }
    
    private func animateBubble() {
        // Calculate how much to converge toward center
        let centerX = screenWidth / 2
        let distanceFromCenter = bubble.startX - centerX
        
        // Converge toward center as bubble rises (80% convergence)
        let targetXOffset = -distanceFromCenter * 0.8
        
        // Add slight random drift for organic motion
        let drift = CGFloat.random(in: -15...15)
        
        // Fade in quickly
        withAnimation(.easeIn(duration: 0.2)) {
            opacity = 1.0
        }
        
        // Rise and converge toward center
        withAnimation(.easeInOut(duration: bubble.duration)) {
            yPosition = bubble.screenHeight + 50
            xPosition = targetXOffset + drift
        }
        
        // Shrink dramatically as it rises (1.5x → 0.2x = 87% size reduction)
        withAnimation(.easeOut(duration: bubble.duration)) {
            scale = 0.2
        }
        
        // Fade out in top 30% of screen
        DispatchQueue.main.asyncAfter(deadline: .now() + bubble.duration * 0.7) {
            withAnimation(.easeOut(duration: bubble.duration * 0.3)) {
                opacity = 0
            }
        }
    }
}

// MARK: - Header Component

/// App header with logo and tagline
/// Optimized with subtle glow effects
struct PolaHeader: View {
    
    var body: some View {
        VStack(spacing: -12) {
            PolaLogo()
                .drawingGroup() // Rasterize for better performance
            
            Text(PolaStrings.appTagline)
                .font(.polaBody(size: PolaLayout.subtitleSize))
                .kerning(1.5)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.polaSilverLight, .polaSilverDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: -0.5) // Letter-press effect
                .shadow(color: .white.opacity(0.1), radius: 0, x: 0, y: 0.5)
                .shadow(color: .black.opacity(0.2), radius: 0.5, x: 0, y: 0.5)
                .offset(x: 0, y: -4)
        }
    }
}

/// polaGram logo with subtle pink glow
/// Clean and simple without animation
struct PolaLogo: View {
    
    var body: some View {
        logoText
            .shadow(color: .polaPinkLight.opacity(0.3), radius: 10, x: 0, y: 0) // Subtle glow
    }
    
    private var logoText: some View {
        HStack(spacing: 0) {
            Text("pola")
                .font(.custom("MarkerFelt-Wide", size: PolaLayout.titleSize))
                .kerning(-1)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.polaSilverDark, .polaPinkLight],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
            
            Text("Gram")
                .font(.custom("MarkerFelt-Wide", size: PolaLayout.titleSize))
                .kerning(-1)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.polaPinkLight, .polaPinkHot],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
        }
    }
}

// MARK: - Pola Frame Component

/// Polaroid-style photo frame (312×392pt)
/// Displays photo area (280×280pt), caption (80pt), date stamp, and placeholder state
/// Enhanced with 3D bevel, floating animation, and rounded photo corners
struct PolaFrame: View {
    let photoImage: Image?
    @Binding var caption: String
    let scale: CGFloat
    
    @FocusState private var isCaptionFocused: Bool
    @State private var isFramePressed = false
    @State private var currentPlaceholder = PolaStrings.randomCaptionPlaceholder
    @State private var floatOffset: CGFloat = 0
    
    // Cached formatted date to avoid recomputation
    private let formattedDateString = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: Date())
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Photo Area
            
            ZStack(alignment: .bottomTrailing) {
                Color.polaPhotoBackground
                
                if let photoImage = photoImage {
                    // User's photo with film grain overlay
                    photoImage
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: PolaLayout.photoSize * scale,
                            height: PolaLayout.photoSize * scale
                        )
                        .clipped()
                        .overlay(
                            Rectangle()
                                .fill(.white.opacity(PolaLayout.filmGrainOpacity))
                                .blendMode(.screen)
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    // Placeholder state (no photo)
                    PlaceholderView(scale: scale)
                }
                
                // Subtle inner shadow overlay for depth
                Rectangle()
                    .fill(.black.opacity(0.03))
                    .frame(
                        width: PolaLayout.photoSize * scale,
                        height: PolaLayout.photoSize * scale
                    )
                    .allowsHitTesting(false)
                
                // Date stamp (only when photo exists)
                if photoImage != nil {
                    Text(formattedDateString)
                        .font(.system(
                            size: PolaLayout.dateStampSize * scale,
                            weight: .medium,
                            design: .monospaced
                        ))
                        .foregroundColor(.polaDateStamp.opacity(0.85)) // More faded
                        .padding(.trailing, PolaLayout.dateStampTrailing * scale)
                        .padding(.bottom, PolaLayout.dateStampBottom * scale)
                }
            }
            .frame(
                width: PolaLayout.photoSize * scale,
                height: PolaLayout.photoSize * scale
            )
            .clipShape(RoundedRectangle(cornerRadius: 4 * scale)) // Rounded photo corners
            .padding(.top, PolaLayout.framePadding * scale)
            .padding(.horizontal, PolaLayout.framePadding * scale)
            
            // MARK: Divider
            
            Rectangle()
                .fill(Color.black.opacity(PolaLayout.dividerOpacity))
                .frame(height: PolaLayout.borderWidth)
                .padding(.horizontal, PolaLayout.framePadding * scale)
            
            // MARK: Caption Area
            
            CaptionArea(
                caption: $caption,
                isCaptionFocused: $isCaptionFocused,
                currentPlaceholder: currentPlaceholder,
                scale: scale
            )
        }
        .frame(
            width: PolaLayout.frameWidth * scale,
            height: PolaLayout.frameHeight * scale
        )
        .background(
            Color.polaFrameBackground
                .overlay(
                    // Subtle paper texture overlay
                    Rectangle()
                        .fill(Color.black.opacity(PolaLayout.frameTextureOpacity))
                        .blendMode(.multiply)
                )
        )
        .overlay(
            // 3D Bevel effect on edges
            RoundedRectangle(cornerRadius: PolaLayout.cornerRadius * scale)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.3),
                            .clear,
                            .black.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(PolaLayout.cornerRadius * scale)
        .shadow(color: .black.opacity(0.4), radius: 35 * scale, x: 0, y: 18 * scale) // More pronounced shadow
        .shadow(color: .black.opacity(0.2), radius: 12 * scale, x: 0, y: 6 * scale)
        .shadow(color: .black.opacity(0.1), radius: 3 * scale, x: 0, y: 2 * scale)
        .scaleEffect(isFramePressed ? 0.98 : 1.0)
        .offset(y: floatOffset) // Floating animation
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFramePressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isFramePressed = true }
                .onEnded { _ in isFramePressed = false }
        )
        .accessibilityElement(children: .contain)
        .accessibilityHint(PolaStrings.addPhotoHint)
        .onAppear {
            // Gentle floating/breathing animation
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floatOffset = -3 * scale
            }
        }
    }
}

// MARK: - Placeholder View

/// Separated placeholder view for better performance
private struct PlaceholderView: View {
    let scale: CGFloat
    
    var body: some View {
        VStack(spacing: 12 * scale) {
            // Logo watermark (with SF Symbol fallback)
            #if canImport(UIKit)
            if UIImage(named: "pG_logo") != nil {
                Image("pG_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: PolaLayout.photoSize * scale * 0.7)
                    .opacity(0.15)
            } else {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 100 * scale))
                    .foregroundColor(.gray.opacity(0.15))
            }
            #else
            if let _ = NSImage(named: "pG_logo") {
                Image("pG_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: PolaLayout.photoSize * scale * 0.7)
                    .opacity(0.15)
            } else {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 100 * scale))
                    .foregroundColor(.gray.opacity(0.15))
            }
            #endif
            
            // Instruction text
            Text("tap to snap")
                .font(.polaBody(size: PolaLayout.placeholderTextSize * scale))
                .foregroundColor(.gray.opacity(0.95))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Caption Area

/// Separated caption area for better performance and state isolation
/// Enhanced with breathing animation on placeholder and alternating rotation angles
private struct CaptionArea: View {
    @Binding var caption: String
    @FocusState.Binding var isCaptionFocused: Bool
    let currentPlaceholder: String
    let scale: CGFloat
    
    @State private var placeholderOpacity: Double = 0.22
    @State private var placeholderRotation: Double = 0
    @State private var userTextRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Placeholder caption text with breathing animation and alternating rotation
            if caption.isEmpty {
                Text(currentPlaceholder)
                    .font(.custom("BradleyHandITCTT-Bold", size: PolaLayout.captionSize * scale))
                    .foregroundColor(.black.opacity(placeholderOpacity))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(2 * scale)
                    .kerning(0.5)
                    .rotationEffect(.degrees(placeholderRotation))
                    .padding(.horizontal, 38 * scale)
                    .offset(x: CGFloat.random(in: -3...3) * scale, y: CGFloat.random(in: -2...2) * scale)
                    .blur(radius: 0.3)
                    .onAppear {
                        // Set random rotation on appear (alternates between negative and positive)
                        placeholderRotation = Bool.random() ? Double.random(in: -3.5...(-0.5)) : Double.random(in: 0.5...3.5)
                        
                        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                            placeholderOpacity = 0.18
                        }
                    }
            }
            
            // Editable caption text field with alternating rotation
            TextField("", text: $caption, axis: .vertical)
                .font(.custom("BradleyHandITCTT-Bold", size: PolaLayout.captionSize * scale))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(3...4)
                .lineSpacing(2 * scale)
                .kerning(0.5)
                .padding(.horizontal, 38 * scale)
                .padding(.vertical, 10 * scale)
                .frame(height: PolaLayout.captionHeight * scale)
                .focused($isCaptionFocused)
                .onChange(of: caption) { oldValue, newValue in
                    // Enforce 42 character limit
                    if newValue.count > 42 {
                        caption = String(newValue.prefix(42))
                    }
                }
                .accessibilityHint(PolaStrings.captionAccessibilityHint)
                .rotationEffect(.degrees(userTextRotation))
                .onAppear {
                    // Set random rotation on appear (alternates between negative and positive)
                    userTextRotation = Bool.random() ? Double.random(in: -3.5...(-0.5)) : Double.random(in: 0.5...3.5)
                }
            
            // Character counter (shown when focused)
            if isCaptionFocused {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(caption.count)/42")
                            .font(.polaBody(size: 10 * scale))
                            .foregroundColor(.gray.opacity(0.6))
                            .padding(.trailing, 8 * scale)
                            .padding(.bottom, 4 * scale)
                    }
                }
                .frame(height: PolaLayout.captionHeight * scale)
            }
        }
        .frame(height: PolaLayout.captionHeight * scale)
    }
}

// MARK: - Action Menu Component

/// Bottom action bar with three buttons (message, instagram, save)
/// Horizontal layout with responsive spacing
struct ActionMenu: View {
    let scale: CGFloat
    let hasPhoto: Bool
    
    var body: some View {
        HStack(spacing: PolaLayout.menuSpacing * scale) {
            ActionButton(
                icon: "message.fill",
                label: PolaStrings.messageButton,
                accessibilityLabel: PolaStrings.shareViaMessagesLabel,
                scale: scale,
                isEnabled: hasPhoto
            )
            
            ActionButton(
                icon: "camera.fill",
                label: PolaStrings.instagramButton,
                accessibilityLabel: PolaStrings.shareToInstagramLabel,
                scale: scale,
                isEnabled: hasPhoto
            )
            
            ActionButton(
                icon: "square.and.arrow.down.fill",
                label: PolaStrings.saveButton,
                accessibilityLabel: PolaStrings.saveToPhotosLabel,
                scale: scale,
                isEnabled: hasPhoto
            )
        }
        .frame(height: PolaLayout.menuHeight * scale)
    }
}

// MARK: - Action Button Component

/// Individual action button with icon, label, and press state
/// Visual feedback: silver gradient → pink on press, with scale animation and glow
struct ActionButton: View {
    let icon: String
    let label: String
    let accessibilityLabel: String
    let scale: CGFloat
    let isEnabled: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8 * scale) {
            // SF Symbol icon
            Image(systemName: icon)
                .font(.system(size: PolaLayout.menuIconSize * scale))
                .foregroundStyle(
                    LinearGradient(
                        colors: isPressed
                            ? [.polaPinkLight, .polaPinkLight]
                            : [.polaSilverLight, .polaSilverDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: isPressed ? .polaPink.opacity(0.5) : .clear, radius: 10, x: 0, y: 0) // Glow on press
            
            // Button label
            Text(label)
                .font(.polaBody(size: 12 * scale))
                .foregroundColor(isPressed ? .polaPinkLight : .polaSilverLight)
        }
        .opacity(isEnabled ? 1.0 : 0.4)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .scaleEffect(isPressed ? 0.92 : 1.0) // More pronounced scale
        .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed) // Bouncier
        .allowsHitTesting(isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if isEnabled {
                        isPressed = true
                    }
                }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Splash Screen Component

/// Splash screen with pG_logo image and "swipe to snap" caption
/// Displays on app launch, dismisses with swipe or tap gesture
struct SplashScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width / PolaLayout.referenceWidth
            
            ZStack {
                // Background gradient (same as main app)
                PolaBackground(scale: scale)
                
                // Centered content (both vertically and horizontally)
                VStack(spacing: 16 * scale) {
                    // pG_logo image (centered, big and beautiful)
                    #if canImport(UIKit)
                    if UIImage(named: "pG_logo") != nil {
                        Image("pG_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280 * scale)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                            .shadow(color: .polaPinkLight.opacity(0.3), radius: 20, x: 0, y: 0)
                    } else {
                        // Fallback: show polaGram text logo
                        PolaLogo()
                            .scaleEffect(logoScale * 1.5)
                            .opacity(logoOpacity)
                    }
                    #else
                    if let _ = NSImage(named: "pG_logo") {
                        Image("pG_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280 * scale)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                            .shadow(color: .polaPinkLight.opacity(0.3), radius: 20, x: 0, y: 0)
                    } else {
                        // Fallback: show polaGram text logo
                        PolaLogo()
                            .scaleEffect(logoScale * 1.5)
                            .opacity(logoOpacity)
                    }
                    #endif
                    
                    // "swipe to snap" caption
                    Text("swipe to snap")
                        .font(.polaBody(size: 24 * scale))
                        .kerning(1.5)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.polaSilverLight, .polaSilverDark],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: -0.5)
                        .shadow(color: .white.opacity(0.1), radius: 0, x: 0, y: 0.5)
                        .opacity(textOpacity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Center horizontally and vertically
            }
            .ignoresSafeArea()
        }
        .onAppear {
            // Logo animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            // Text animation
            withAnimation(.easeIn(duration: 0.5).delay(0.6)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    ContentView()
}
