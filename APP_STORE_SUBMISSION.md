# polaGram App Store Submission Guide

## Pre-Submission Checklist

### Code & Build
- [x] App version set to 2.3
- [x] Build number incremented
- [x] All features tested on device
- [x] No crash on launch
- [x] Memory profiled (no leaks)
- [x] Works in airplane mode

### Legal
- [x] Privacy Policy (PRIVACY.md, privacy.html)
- [x] Terms of Service (TERMS.md)
- [x] No trademarked terms ("Polaroid" removed)
- [x] Copyright notice updated

### Metadata
- [x] App name: polaGram
- [x] Subtitle: Instant Photo Memories
- [x] Description written
- [x] Keywords defined
- [x] What's New text ready
- [x] Support URL: https://www.polagram.app
- [x] Privacy Policy URL: https://www.polagram.app/privacy.html

---

## Screenshot Requirements

### Required Device Sizes

| Device | Resolution | Required |
|--------|------------|----------|
| iPhone 6.7" (15 Pro Max) | 1290 x 2796 | Yes |
| iPhone 6.5" (11 Pro Max) | 1242 x 2688 | Yes |
| iPhone 5.5" (8 Plus) | 1242 x 2208 | Yes |
| iPad Pro 12.9" | 2048 x 2732 | If supporting iPad |

### Screenshot Suggestions (5-10 per size)

1. **Splash/Welcome** - App launch with logo
2. **Empty State** - Pola frame with "tap to snap"
3. **Developing** - Photo mid-development with "shake it" hint
4. **Completed Photo** - Finished pola with caption
5. **Vintage Effect** - Photo with visible coffee stain or fold
6. **Caption Editor** - Adding handwritten text
7. **Gallery View** - Stack of saved polas
8. **Share Options** - Action menu visible
9. **Mangled Effect** - Rare heavily-damaged pola (optional, fun)
10. **Before/After** - Original vs pola-fied (optional)

### Screenshot Tips
- Use real photos (not stock images)
- Show the app in action, not just static screens
- Capture on actual devices for authenticity
- Consider adding marketing text overlays in Figma/Sketch

### Capturing Screenshots

**On Device:**
1. Press Side Button + Volume Up simultaneously
2. Screenshots save to Photos app
3. AirDrop to Mac for editing

**In Simulator:**
```bash
# iPhone 15 Pro Max (6.7")
xcrun simctl boot "iPhone 15 Pro Max"
xcrun simctl io booted screenshot screenshot_6.7.png

# iPhone 11 Pro Max (6.5")
xcrun simctl boot "iPhone 11 Pro Max"
xcrun simctl io booted screenshot screenshot_6.5.png

# iPhone 8 Plus (5.5")
xcrun simctl boot "iPhone 8 Plus"
xcrun simctl io booted screenshot screenshot_5.5.png
```

---

## App Preview Video (Optional)

### Specifications
- Duration: 15-30 seconds
- Resolution: Match screenshot sizes
- Format: H.264, .mov or .mp4
- No letterboxing

### Suggested Flow
1. App launch (2s)
2. Tap to capture photo (3s)
3. Photo developing with shake (8s)
4. Add caption (4s)
5. Save/share (3s)
6. End card with app name (2s)

### Recording
- Use QuickTime Player > File > New Movie Recording
- Select iPhone as camera source
- Or use Xcode's built-in screen recording

---

## App Store Connect Setup

### 1. Create App Record
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. My Apps > + > New App
3. Fill in:
   - Platform: iOS
   - Name: polaGram
   - Primary Language: English (U.S.)
   - Bundle ID: io.mediaBrilliance.polaGram
   - SKU: polagram-2026
   - User Access: Full Access

### 2. App Information
- Category: Photo & Video
- Secondary Category: Entertainment
- Content Rights: Does not contain third-party content
- Age Rating: Complete questionnaire (all "None" = 4+)

### 3. Pricing and Availability
- Price: Free
- Availability: All territories (or select specific)
- Pre-Orders: No (unless desired)

### 4. App Privacy
Complete the privacy questionnaire:
- **Data Not Collected**: Select this option
- polaGram collects no user data

### 5. Version Information
- Screenshots: Upload all required sizes
- App Preview: Upload if created
- Promotional Text: (from metadata file)
- Description: (from metadata file)
- Keywords: (from metadata file)
- Support URL: https://www.polagram.app
- Marketing URL: https://www.polagram.app
- Version: 2.3
- Copyright: © 2026 mediaBrilliance
- Contact Info: Fill in developer contact
- Notes for Review: (see below)

---

## Build & Upload

### Archive in Xcode
1. Select "Any iOS Device" as destination
2. Product > Archive
3. Wait for archive to complete
4. Window > Organizer opens automatically

### Upload to App Store Connect
1. In Organizer, select the archive
2. Click "Distribute App"
3. Select "App Store Connect"
4. Choose "Upload"
5. Select options:
   - Include bitcode: No (deprecated)
   - Upload symbols: Yes
   - Manage signing: Automatic
6. Click Upload
7. Wait for processing (5-15 minutes)

### After Upload
1. Go to App Store Connect
2. Select polaGram > iOS App > Version 2.3
3. Build will appear in ~15-30 minutes
4. Select the build
5. Complete any missing information
6. Submit for Review

---

## Review Notes

Paste this in "Notes for Review":

```
polaGram is a photo app that creates instant-style photos with vintage effects.

KEY FEATURES TO TEST:
1. Tap the pola frame to capture/select a photo
2. Watch the 20-second development animation
3. Shake the device to speed up development
4. Tap below the photo to add a caption
5. Use the bottom buttons to save or share

PERMISSIONS USED:
- Camera: To capture photos
- Photo Library: To select/save photos
- Motion: For shake detection (speeds up development)

NO ACCOUNT REQUIRED:
The app works entirely offline with no sign-in.

DEMO CREDENTIALS:
N/A - No login required

SPECIAL NOTES:
- Shake detection requires a physical device
- Sound effects require ringer to be ON
- The "mangled" vintage effect (1% chance) is intentional
```

---

## Common Rejection Reasons (Avoid These)

### Metadata Issues
- ❌ Using "Polaroid" in description (trademark)
- ❌ Screenshots with device bezels
- ❌ Placeholder text visible
- ❌ Broken privacy policy link

### Functionality Issues
- ❌ App crashes on launch
- ❌ Features don't work as described
- ❌ Permissions requested without clear purpose

### Design Issues
- ❌ Poor performance / lag
- ❌ UI doesn't adapt to all screen sizes
- ❌ Buttons too small to tap

### Guideline Violations
- ❌ Misleading app name/description
- ❌ Privacy policy missing required info
- ❌ Hidden features or functionality

---

## Post-Submission

### Review Timeline
- Typical: 24-48 hours
- Complex apps: Up to 7 days
- Expedited review: Available for critical bugs

### If Rejected
1. Read rejection reason carefully
2. Fix the specific issue mentioned
3. Reply in Resolution Center
4. Resubmit (goes to front of queue)

### After Approval
1. Set release date (immediately or scheduled)
2. Monitor Crash Reports in App Store Connect
3. Respond to user reviews
4. Plan next update

---

## Quick Reference

**Bundle ID:** `io.mediaBrilliance.polaGram`
**Version:** 2.3
**Build:** (increment each upload)
**Category:** Photo & Video
**Age Rating:** 4+
**Price:** Free
**Support URL:** https://www.polagram.app
**Privacy URL:** https://www.polagram.app/privacy.html

---

Ready to submit! 🚀
