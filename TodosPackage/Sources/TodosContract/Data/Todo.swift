import Foundation

public struct Todo: Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let completed: Bool

    public init(id: Int, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}
