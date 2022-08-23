import SwiftUI

import TodosBackend
import TodosContract
import TodosFrontend

@main
struct TodosApp: App {
    @State var todos: [Todo]

    var body: some Scene {
        WindowGroup {
            TodosView(todos: todos, onToggleTodo: handleToggleTodo)
        }
    }

    private let toggleTodo: (ToggleTodoCommand) -> CommandStatus
    private let selectTodos: (SelectTodosQuery) -> SelectTodosQueryResult

    init() {
        //
        // Build
        //
        let todosRepository = MemoryTodoRepository([
            Todo(id: 1, title: "Taste JavaScript", completed: true),
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ])
        toggleTodo = createToggleTodoCommandHandler(todosRepository: todosRepository)
        selectTodos = createSelectTodosQueryHandler(todosRepository: todosRepository)

        //
        // Run
        //
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }

    private func handleToggleTodo(_ command: ToggleTodoCommand) {
        _ = toggleTodo(command)
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }
}
