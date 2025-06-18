import Foundation
import SwiftData

@Model
final class TodoItem {
    let id: UUID
    var title: String
    var itemDescription: String // Renamed from description to avoid conflict
    var isCompleted: Bool
    var createdAt: Date

    init(id: UUID = UUID(), title: String = "", itemDescription: String = "", isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.itemDescription = itemDescription
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
