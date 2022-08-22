import Foundation

import TodosContract

public func createSelectTodosQueryHandler(
    todosRepository: TodosRepository
) -> (SelectTodosQuery) -> SelectTodosQueryResult {
    { _ in
        let todos = todosRepository.load()
        return SelectTodosQueryResult(todos: todos)
    }
}
