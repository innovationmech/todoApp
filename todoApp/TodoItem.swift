import Foundation

struct TodoItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var note: String
    var isCompleted: Bool
    var reminderDate: Date?
    
    init(id: UUID = UUID(), title: String, note: String, isCompleted: Bool = false, reminderDate: Date? = nil) {
        self.id = id
        self.title = title
        self.note = note
        self.isCompleted = isCompleted
        self.reminderDate = reminderDate
    }
    
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.note == rhs.note &&
               lhs.isCompleted == rhs.isCompleted &&
               lhs.reminderDate == rhs.reminderDate
    }
}