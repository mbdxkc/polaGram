# polaGram Memory Profiling Guide

## Overview

This guide documents memory profiling strategies for polaGram and identifies areas to monitor.

## Key Areas to Profile

### 1. ChampagneBubbles Animation
**What to watch:**
- Bubble array size (capped at 150)
- Timer retention
- Animation state accumulation

**Expected behavior:**
- Memory should stabilize after ~5 seconds (spawn rate slows)
- Max ~150 Bubble structs in memory (~1KB total)
- Single Timer instance

**How to test:**
1. Open Instruments > Allocations
2. Launch app, wait on main screen for 30 seconds
3. Monitor "Bubble" allocations
4. Verify count stays below 150

### 2. Image Handling
**What to watch:**
- UIImage/CGImage allocations during photo selection
- ImageRenderer memory spikes during save/share
- Photo picker memory after dismissal

**Expected behavior:**
- Memory should return to baseline after clearing photo
- ImageRenderer spikes are temporary (garbage collected after)
- No retained image data after clearing

**How to test:**
1. Open Instruments > Allocations
2. Add photo, wait for development
3. Save/share multiple times
4. Clear photo
5. Compare memory to baseline

### 3. Timer Management
**What to watch:**
- developmentTimer lifecycle
- ChampagneBubbles timer lifecycle
- ShakeDetector CMMotionManager updates

**Expected behavior:**
- Development timer invalidated after completion
- Development timer invalidated on photo clear
- No timer leaks on view disappear

**How to test:**
1. Open Instruments > Time Profiler
2. Monitor timer activity during development
3. Verify timers stop after:
   - Development completes
   - Photo cleared
   - App backgrounded

### 4. ShakeDetector (iOS)
**What to watch:**
- CMMotionManager accelerometer data
- Combine subscription retention
- ObservableObject memory

**Expected behavior:**
- Updates stop when view disappears
- Single CMMotionManager instance
- Memory stable during shake detection

**How to test:**
1. Profile with Instruments > Energy Log
2. Monitor accelerometer activity
3. Verify updates stop on background

## Profiling Commands

### Xcode Instruments
```bash
# Open Instruments with Allocations template
instruments -t "Allocations"

# Open Instruments with Leaks template
instruments -t "Leaks"

# Open Instruments with Time Profiler
instruments -t "Time Profiler"
```

### Quick Memory Check (Debug)
Add this to ContentView for debug builds:
```swift
#if DEBUG
func logMemory() {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
        }
    }
    if kerr == KERN_SUCCESS {
        print("Memory: \(info.resident_size / 1024 / 1024) MB")
    }
}
#endif
```

## Known Optimizations (v1.3)

### ChampagneBubbles
- **Timer frequency:** 100fps -> 30fps (3x CPU reduction)
- **Max bubbles:** 500 -> 150 (3x memory reduction)
- **Spawn logic:** Removed Date() allocations, use frame counter

### WornText
- **CharStyle caching:** Deterministic pseudo-random values
- **No random() in view body:** Prevents unnecessary redraws

### Development Timer
- **Weak reference:** Prevents retain cycle
- **Cleanup on clear:** Timer invalidated when photo cleared

## Baseline Memory Expectations

| State | Expected Memory |
|-------|-----------------|
| Launch (splash) | ~50-80 MB |
| Main screen (no photo) | ~80-100 MB |
| With photo (developing) | ~120-150 MB |
| With photo (developed) | ~100-130 MB |
| After clear | ~80-100 MB (return to baseline) |

## Red Flags

Watch for these issues:

1. **Memory growth over time** - Indicates leak
2. **Memory not returning after clear** - Retained images
3. **High CPU during idle** - Timer not stopping
4. **Growing allocation count** - Object accumulation

## Recommended Profiling Session

1. Launch app fresh
2. Wait 30 seconds on splash (baseline)
3. Dismiss splash, wait 30 seconds
4. Add photo, wait for development (20 seconds)
5. Edit caption
6. Share via Messages
7. Share via Instagram
8. Save to Photos
9. Clear photo
10. Repeat steps 4-9 three times
11. Compare final memory to step 3 baseline

Memory should return to within 10% of baseline after clearing photo.
