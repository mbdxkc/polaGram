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
    /// Stores filter raw values as comma-separated string for SwiftData compatibility
    var filterRawValues: String?

    /// Legacy single filter support (backwards compatibility)
    var filterRawValue: Int? {
        get {
            guard let values = filterRawValues, let first = values.split(separator: ",").first else { return nil }
            return Int(first)
        }
        set {
            filterRawValues = newValue.map { String($0) }
        }
    }

    /// All applied filters
    var filters: [PolaFilter] {
        guard let values = filterRawValues else { return [] }
        return values.split(separator: ",").compactMap { Int($0) }.compactMap { PolaFilter(rawValue: $0) }
    }

    /// Legacy single filter accessor
    var filter: PolaFilter? {
        filters.first
    }

    init(imageData: Data, caption: String, createdAt: Date = Date(), filterRawValue: Int? = nil) {
        self.imageData = imageData
        self.caption = caption
        self.createdAt = createdAt
        self.filterRawValues = filterRawValue.map { String($0) }
    }

    init(imageData: Data, caption: String, createdAt: Date = Date(), filterRawValues: [Int]) {
        self.imageData = imageData
        self.caption = caption
        self.createdAt = createdAt
        self.filterRawValues = filterRawValues.isEmpty ? nil : filterRawValues.map(String.init).joined(separator: ",")
    }
}
