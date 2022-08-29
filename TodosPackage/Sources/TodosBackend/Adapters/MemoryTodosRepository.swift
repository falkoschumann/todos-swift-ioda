import Foundation

import TodosContract

public class MemoryTodosRepository: TodosRepository {
    private var todos: [Todo]

    public init(_ todos: [Todo]) {
        self.todos = todos
    }

    public func load() -> [Todo] {
        todos
    }

    public func store(todos: [Todo]) {
        self.todos = todos
    }
}
