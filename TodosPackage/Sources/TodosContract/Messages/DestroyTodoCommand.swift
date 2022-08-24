import Foundation

public struct DestroyTodoCommand {
    public let id: Int

    public init(id: Int) {
        self.id = id
    }
}
