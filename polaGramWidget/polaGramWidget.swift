//
//  polaGramWidget.swift
//  polaGramWidget
//
//  ┌─────────────────────────────────────────────────────────────────────────┐
//  │  polaGram Widget - Home Screen Photo Display                            │
//  │                                                                         │
//  │  Shows a random saved pola from the gallery on the home screen.        │
//  │  Supports small and medium widget sizes.                               │
//  └─────────────────────────────────────────────────────────────────────────┘
//
//  SETUP INSTRUCTIONS
//  ──────────────────
//  1. In Xcode: File > New > Target > Widget Extension
//  2. Name it "polaGramWidget"
//  3. Add App Group capability to both app and widget targets:
//     - Signing & Capabilities > + Capability > App Groups
//     - Add group: "group.com.yourteam.polaGram"
//  4. Update SavedPola model to use App Group container
//  5. Copy this file to the widget extension target
//

import WidgetKit
import SwiftUI
import SwiftData
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Widget Entry

/// Timeline entry containing pola data for display
struct PolaEntry: TimelineEntry {
    let date: Date
    let imageData: Data?
    let caption: String
    let isEmpty: Bool

    static var placeholder: PolaEntry {
        PolaEntry(
            date: Date(),
            imageData: nil,
            caption: "Your polas here",
            isEmpty: true
        )
    }
}

// MARK: - Timeline Provider

/// Provides timeline entries for the widget
struct PolaTimelineProvider: TimelineProvider {

    func placeholder(in context: Context) -> PolaEntry {
        PolaEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (PolaEntry) -> Void) {
        // Return placeholder for preview
        completion(PolaEntry.placeholder)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PolaEntry>) -> Void) {
        // Fetch random saved pola from SwiftData
        // Note: Requires App Group configuration for shared container access

        Task {
            do {
                // Configure SwiftData with App Group container
                // Replace "group.com.yourteam.polaGram" with your actual App Group ID
                let schema = Schema([SavedPola.self])
                let modelConfiguration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: false,
                    groupContainer: .identifier("group.com.yourteam.polaGram")
                )

                let container = try ModelContainer(
                    for: schema,
                    configurations: [modelConfiguration]
                )

                let context = ModelContext(container)

                // Fetch all saved polas
                let descriptor = FetchDescriptor<SavedPola>(
                    sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
                )
                let polas = try context.fetch(descriptor)

                let entry: PolaEntry
                if polas.isEmpty {
                    entry = PolaEntry(
                        date: Date(),
                        imageData: nil,
                        caption: "No polas yet",
                        isEmpty: true
                    )
                } else {
                    // Pick a random pola
                    let randomPola = polas.randomElement()!
                    entry = PolaEntry(
                        date: Date(),
                        imageData: randomPola.imageData,
                        caption: randomPola.caption,
                        isEmpty: false
                    )
                }

                // Update every 30 minutes
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

                await MainActor.run {
                    completion(timeline)
                }

            } catch {
                // Fallback to placeholder on error
                let entry = PolaEntry.placeholder
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))

                await MainActor.run {
                    completion(timeline)
                }
            }
        }
    }
}

// MARK: - Widget Views

/// Small widget view
struct SmallPolaWidgetView: View {
    let entry: PolaEntry

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.12, blue: 0.14), Color(red: 0.08, green: 0.08, blue: 0.10)],
                startPoint: .top,
                endPoint: .bottom
            )

            if entry.isEmpty {
                // Empty state
                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.gray)
                    Text("Tap to add")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            } else if let imageData = entry.imageData,
                      let uiImage = UIImage(data: imageData) {
                // Pola image
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(8)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
        }
    }
}

/// Medium widget view
struct MediumPolaWidgetView: View {
    let entry: PolaEntry

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.12, blue: 0.14), Color(red: 0.08, green: 0.08, blue: 0.10)],
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(spacing: 16) {
                if entry.isEmpty {
                    // Empty state
                    VStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.gray)
                        Text("Your polas will appear here")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                } else if let imageData = entry.imageData,
                          let uiImage = UIImage(data: imageData) {
                    // Pola image
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        .padding(.leading, 12)
                        .padding(.vertical, 12)

                    // Caption and branding
                    VStack(alignment: .leading, spacing: 8) {
                        Spacer()
                        if !entry.caption.isEmpty {
                            Text(entry.caption)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(2)
                        }
                        Text("polaGram")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                    }
                    .padding(.trailing, 16)
                }
            }
        }
    }
}

// MARK: - Widget Entry View

struct PolaWidgetEntryView: View {
    var entry: PolaEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallPolaWidgetView(entry: entry)
        case .systemMedium:
            MediumPolaWidgetView(entry: entry)
        default:
            SmallPolaWidgetView(entry: entry)
        }
    }
}

// MARK: - Widget Configuration

@main
struct polaGramWidget: Widget {
    let kind: String = "polaGramWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PolaTimelineProvider()) { entry in
            PolaWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("polaGram")
        .description("Display a random pola from your gallery")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    polaGramWidget()
} timeline: {
    PolaEntry.placeholder
}

#Preview(as: .systemMedium) {
    polaGramWidget()
} timeline: {
    PolaEntry.placeholder
}
