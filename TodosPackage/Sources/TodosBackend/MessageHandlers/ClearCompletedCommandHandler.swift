import Foundation

import TodosContract

public func createClearCompletedCommandHandler(
    todosRepository: TodosRepository
) -> (ClearCompletedCommand) -> CommandStatus {
    func clearCompleted(_ todos: [Todo]) -> [Todo] {
        todos.filter { e in !e.completed }
    }

    return { _ in
        do {
            var todos = try todosRepository.load()
            todos = clearCompleted(todos)
            try todosRepository.store(todos: todos)
            return .success
        } catch {
            return .failure(errorMessage: "Could not clear completed todos: \(error.localizedDescription)")
        }
    }
}
