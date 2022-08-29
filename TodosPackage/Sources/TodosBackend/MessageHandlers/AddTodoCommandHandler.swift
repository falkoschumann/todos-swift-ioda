import Foundation

import TodosContract

public func createAddTodoCommandHandler(todosRepository: TodosRepository) -> (AddTodoCommand) -> CommandStatus {
    func getNextId(_ todos: [Todo]) -> Int {
        let lastId = todos.map { e in e.id }.max() ?? 0
        return lastId + 1
    }

    func addTodo(_ todos: [Todo], _ id: Int, _ title: String) -> [Todo] {
        todos + [Todo(id: id, title: title, completed: false)]
    }

    return { command in
        do {
            let title = command.title.trimmingCharacters(in: .whitespaces)
            if title.isEmpty {
                return .success
            }

            var todos = try todosRepository.load()
            let id = getNextId(todos)
            todos = addTodo(todos, id, title)
            try todosRepository.store(todos: todos)
            return .success
        } catch {
            return .failure(
                errorMessage: "Todo \"\(command.title)\" could not be added: \(error.localizedDescription)"
            )
        }
    }
}
