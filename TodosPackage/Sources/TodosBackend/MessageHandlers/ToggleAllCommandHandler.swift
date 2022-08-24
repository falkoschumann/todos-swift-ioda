import Foundation

import TodosContract

public func createToggleAllCommandHandler(todosRepository: TodosRepository) -> (ToggleAllCommand) -> CommandStatus {
    func toggleAll(_ todos: [Todo], _ checked: Bool) -> [Todo] {
        todos.map { e in Todo(id: e.id, title: e.title, completed: checked) }
    }

    return { command in
        var todos = todosRepository.load()
        todos = toggleAll(todos, command.checked)
        todosRepository.store(todos: todos)
        return .success
    }
}
