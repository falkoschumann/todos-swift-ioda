import Foundation

public struct AddTodoCommand {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}
