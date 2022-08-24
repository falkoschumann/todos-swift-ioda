import Foundation

import TodosContract

public func createClearCompletedCommandHandler(
    todosRepository: TodosRepository
) -> (ClearCompletedCommand) -> CommandStatus {
    func clearCompleted(_ todos: [Todo]) -> [Todo] {
        todos.filter { e in !e.completed }
    }

    return { _ in
        var todos = todosRepository.load()
        todos = clearCompleted(todos)
        todosRepository.store(todos: todos)
        return .success
    }
}
