import SwiftUI

import TodosBackend
import TodosContract
import TodosFrontend

@main
struct TodosApp: App {
    var todos: [Todo] = []

    var body: some Scene {
        WindowGroup {
            TodosView(todos: todos)
        }
    }

    private let selectTodos: (SelectTodosQuery) -> SelectTodosQueryResult

    init() {
        //
        // Build
        //
        let todosRepository = MemoryTodoRepository([
            Todo(id: 1, title: "Taste JavaScript", completed: true),
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ])
        selectTodos = createSelectTodosQueryHandler(todosRepository: todosRepository)

        //
        // Run
        //
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }
}
