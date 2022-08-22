import Foundation

public struct SelectTodosQuery {
    public init() {}
}

public struct SelectTodosQueryResult: Equatable {
    public let todos: [Todo]

    public init(todos: [Todo]) {
        self.todos = todos
    }
}
