//
//  CameraView.swift
//  polaGram
//
//  Camera capture and message composer views.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
import AVFoundation
import MessageUI

// MARK: - Camera View

/// SwiftUI wrapper for UIKit's camera interface.
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: Image?
    var onPhotoTaken: () -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        picker.cameraDevice = .rear
        picker.cameraFlashMode = .auto
        picker.showsCameraControls = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[.originalImage] as? UIImage else {
                parent.dismiss()
                return
            }

            let finalImage: UIImage
            if picker.cameraDevice == .front {
                finalImage = uiImage.withHorizontallyFlippedOrientation()
            } else {
                finalImage = uiImage
            }

            parent.image = Image(uiImage: finalImage)
            parent.onPhotoTaken()
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Message Composer

struct MessageComposer: UIViewControllerRepresentable {
    let image: UIImage
    var onFinish: (Bool) -> Void

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = context.coordinator

        if MFMessageComposeViewController.canSendAttachments(),
           let data = image.jpegData(compressionQuality: 0.95) {
            controller.addAttachmentData(data, typeIdentifier: "public.jpeg", filename: "pola.jpg")
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageComposer

        init(_ parent: MessageComposer) { self.parent = parent }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            let sent = result == .sent
            controller.dismiss(animated: true) {
                self.parent.onFinish(sent)
            }
        }
    }
}

// MARK: - Message Image Item

/// Identifiable wrapper for UIImage to use with sheet(item:)
struct MessageImageItem: Identifiable {
    let id = UUID()
    let image: UIImage
}

#endif
