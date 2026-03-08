//
//  Strings.swift
//  polaGram
//
//  Centralized text content for the entire app.
//  Extracted from DesignTokens.swift for maintainability.
//

import Foundation

// MARK: - String Constants

struct PolaStrings {

    // ─────────────────────────────────────────────────────────────────────────
    // Branding
    // ─────────────────────────────────────────────────────────────────────────

    static let appTitle = "polaGram"
    static let appTagline = "share what matters"

    // ─────────────────────────────────────────────────────────────────────────
    // Caption Placeholders
    // ─────────────────────────────────────────────────────────────────────────

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
        "living for this chaos and refusing to apologize",
        "pure magic",
        "forever mood",
        "unreal tbh",
        "peak vibes",
        "golden hour",
        "main character",
        "soft life",
        "chef's kiss",
        "no filter",
        "caught feelings",
        "big energy",
        "iconic moment",
        "living rent free",
        "slay behavior",
        "heart eyes",
        "god tier",
        "aesthetic af",
        "brain rot",
        "just vibes",
        "immaculate",
        "send tweet",
        "period.",
        "it's giving",
        "touch grass",
        "too real",
        "real ones know",
        "built different",
        "no thoughts",
        "literally obsessed",
        "vibe check",
        "dead serious",
        "that's it",
        "couldn't be me",
        "felt that",
        "this energy >>",
        "lowkey iconic",
        "actually insane",
        "emotional damage",
        "caught lacking",
        "top tier",
        "pure chaos"
    ]

    static var randomCaptionPlaceholder: String {
        captionPlaceholders.randomElement() ?? captionPlaceholders[0]
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Action Button Labels
    // ─────────────────────────────────────────────────────────────────────────

    static let messageButton   = "Message"
    static let instagramButton = "Instagram"
    static let saveButton      = "Save"
    static let galleryButton   = "Gallery"

    // ─────────────────────────────────────────────────────────────────────────
    // Accessibility Labels & Hints
    // ─────────────────────────────────────────────────────────────────────────

    // Photo interaction
    static let addPhotoHint             = "double tap to select or capture a photo"
    static let selectedPhotoLabel       = "selected photo"
    static let photoAreaLabel           = "photo area"
    static let photoPlaceholderLabel    = "tap to add photo"

    // Caption
    static let captionAccessibilityHint = "double tap to edit caption"
    static let captionEditorLabel       = "caption editor"
    static let captionEditorHint        = "type your caption, 24 characters maximum"

    // Action buttons
    static let shareViaMessagesLabel    = "share via messages"
    static let shareToInstagramLabel    = "share to instagram stories"
    static let saveToPhotosLabel        = "save to photos"

    // Clear photo button
    static let clearPhotoLabel          = "clear photo"
    static let clearPhotoHint           = "double tap to remove the current photo and start over"

    // Development animation
    static let developingPhotoLabel     = "photo developing"
    static let developingPhotoHint      = "shake device to develop faster"

    // Editor buttons
    static let cancelButtonLabel        = "cancel"
    static let doneButtonLabel          = "save caption"

    // Splash screen
    static let splashScreenLabel        = "polaGram splash screen"
    static let splashScreenHint         = "swipe or tap to dismiss"

    // Gallery
    static let galleryLabel             = "photo gallery"
    static let galleryHint              = "swipe left or right to browse saved polas"
    static let galleryEmptyLabel        = "gallery is empty, save a pola to see it here"
    static let closeGalleryLabel        = "close gallery"
    static let deletePolaLabel          = "delete pola"
    static let deletePolaHint           = "double tap to permanently delete this pola"
    static let sharePolaLabel           = "share pola"
    static let sharePolaHint            = "double tap to share this pola"
}
