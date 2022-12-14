import Foundation

import TodosContract

public func createToggleTodoCommandHandler(todosRepository: TodosRepository) -> (ToggleTodoCommand) -> CommandStatus {
    func toggleTodo(_ todos: [Todo], _ id: Int) -> [Todo] {
        todos.map { e in
            if e.id != id {
                return e
            }

            return Todo(id: e.id, title: e.title, completed: !e.completed)
        }
    }

    return { command in
        do {
            var todos = try todosRepository.load()
            todos = toggleTodo(todos, command.id)
            try todosRepository.store(todos: todos)
            return .success
        } catch {
            return .failure(
                errorMessage: "Todo \"\(command.id)\" could not be toggled: \(error.localizedDescription)"
            )
        }
    }
}
