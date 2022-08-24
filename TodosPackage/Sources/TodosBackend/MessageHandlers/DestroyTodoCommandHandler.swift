import Foundation

import TodosContract

public func createDestroyTodoCommandHandler(todosRepository: TodosRepository) -> (DestroyTodoCommand) -> CommandStatus {
    func destroyTodo(_ todos: [Todo], _ id: Int) -> [Todo] {
        todos.filter { e in e.id != id }
    }

    return { command in
        var todos = todosRepository.load()
        todos = destroyTodo(todos, command.id)
        todosRepository.store(todos: todos)
        return .success
    }
}
