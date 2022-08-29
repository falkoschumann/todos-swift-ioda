import Foundation

import TodosContract

public func createDestroyTodoCommandHandler(todosRepository: TodosRepository) -> (DestroyTodoCommand) -> CommandStatus {
    func destroyTodo(_ todos: [Todo], _ id: Int) -> [Todo] {
        todos.filter { e in e.id != id }
    }

    return { command in
        do {
            var todos = try todosRepository.load()
            todos = destroyTodo(todos, command.id)
            try todosRepository.store(todos: todos)
            return .success
        } catch {
            return .failure(
                errorMessage: "Todo \"\(command.id)\" could not be destroyed: \(error.localizedDescription)"
            )
        }
    }
}
