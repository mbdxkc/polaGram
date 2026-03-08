//
//  PolaDetailView.swift
//  polaGram
//
//  Full-size pola viewer with share and delete actions.
//  Tap background or X to dismiss, presented from GalleryView.
//

import SwiftUI
import SwiftData
#if canImport(UIKit)
import UIKit
#endif

struct PolaDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let savedPola: SavedPola
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false
    @State private var showShareSheet = false

    var body: some View {
        GeometryReader { geometry in
            let scale = min(max(geometry.size.width / PolaLayout.referenceWidth, PolaLayout.minScale), PolaLayout.maxScale)

            ZStack {
                Color.black.ignoresSafeArea()
                    .onTapGesture { dismiss() }

                VStack(spacing: 24) {
                    closeButton
                    Spacer()
                    polaImage
                    dateLabel
                    Spacer()
                    actionButtons(scale: scale)
                }
            }
        }
        .confirmationDialog("Delete this pola?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { deletePola() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
        #if canImport(UIKit)
        .sheet(isPresented: $showShareSheet) {
            if let uiImage = UIImage(data: savedPola.imageData) {
                ShareSheet(items: [uiImage])
            }
        }
        #endif
    }

    // MARK: - Subviews

    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                SoundManager.shared.playHaptic(.light)
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
            }
            .accessibilityLabel("Close")
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var polaImage: some View {
        Group {
            #if canImport(UIKit)
            if let uiImage = UIImage(data: savedPola.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: PolaLayout.frameWidth * 1.1, maxHeight: PolaLayout.frameHeight * 1.1)
                    .clipShape(RoundedRectangle(cornerRadius: PolaLayout.cornerRadius))
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            } else {
                RoundedRectangle(cornerRadius: PolaLayout.cornerRadius)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: PolaLayout.frameWidth * 1.1, height: PolaLayout.frameHeight * 1.1)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                    )
            }
            #endif
        }
    }

    private var dateLabel: some View {
        Text(savedPola.createdAt.formatted(date: .long, time: .shortened))
            .font(.polaBodyBold(size: 15))
            .foregroundColor(.polaSilverLight.opacity(0.8))
            .padding(.top, 8)
            .accessibilityLabel("Saved on \(savedPola.createdAt.formatted(date: .long, time: .shortened))")
    }

    private func actionButtons(scale: CGFloat) -> some View {
        HStack(spacing: 0) {
            ActionButton(
                icon: "square.and.arrow.up",
                label: "Share",
                accessibilityLabel: PolaStrings.sharePolaLabel,
                scale: scale,
                isEnabled: true
            ) {
                showShareSheet = true
            }

            Spacer()

            ActionButton(
                icon: "trash",
                label: "Delete",
                accessibilityLabel: PolaStrings.deletePolaLabel,
                scale: scale,
                isEnabled: true
            ) {
                showDeleteConfirmation = true
            }
        }
        .frame(width: PolaLayout.frameWidth * scale)
        .padding(.bottom, 40)
    }

    // MARK: - Actions

    private func deletePola() {
        modelContext.delete(savedPola)
        onDelete()
        dismiss()
    }
}

// MARK: - Share Sheet

#if canImport(UIKit)
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif
