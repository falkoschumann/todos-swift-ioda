import Foundation

import TodosContract

public func createToggleAllCommandHandler(todosRepository: TodosRepository) -> (ToggleAllCommand) -> CommandStatus {
    func toggleAll(_ todos: [Todo], _ checked: Bool) -> [Todo] {
        todos.map { e in Todo(id: e.id, title: e.title, completed: checked) }
    }

    return { command in
        do {
            var todos = try todosRepository.load()
            todos = toggleAll(todos, command.checked)
            try todosRepository.store(todos: todos)
            return .success
        } catch {
            var state: String
            if command.checked {
                state = "completed"
            } else {
                state = "active"
            }
            return .failure(errorMessage: "Could not set all todos as \(state): \(error.localizedDescription)")
        }
    }
}
