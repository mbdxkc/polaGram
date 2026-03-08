//
//  SavedPola.swift
//  polaGram
//
//  SwiftData model for persisting saved polas. Images are pre-rendered
//  JPEGs with frame/filter/caption baked in, stored externally for efficiency.
//

import Foundation
import SwiftData

@Model
final class SavedPola {
    @Attribute(.externalStorage) var imageData: Data
    var caption: String
    var createdAt: Date
    var filterRawValue: Int?

    var filter: PolaFilter? {
        guard let rawValue = filterRawValue else { return nil }
        return PolaFilter(rawValue: rawValue)
    }

    init(imageData: Data, caption: String, createdAt: Date = Date(), filterRawValue: Int? = nil) {
        self.imageData = imageData
        self.caption = caption
        self.createdAt = createdAt
        self.filterRawValue = filterRawValue
    }
}
