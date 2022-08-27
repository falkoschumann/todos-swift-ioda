import Foundation

import TodosContract

public func createSaveTodoCommandHandler(todosRepository: TodosRepository) -> (SaveTodoCommand) -> CommandStatus {
    func saveTodo(_ todos: [Todo], _ id: Int, _ title: String) -> [Todo] {
        var newTodos: [Todo] = []
        for todo in todos {
            if todo.id != id {
                newTodos += [todo]
                continue
            }

            let newTitle = title.trimmingCharacters(in: .whitespaces)
            if newTitle.isEmpty {
                continue
            }

            newTodos += [Todo(id: todo.id, title: newTitle, completed: todo.completed)]
        }
        return newTodos
    }

    return { command in
        var todos = todosRepository.load()
        todos = saveTodo(todos, command.id, command.title)
        todosRepository.store(todos: todos)
        return .success
    }
}
