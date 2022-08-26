import SwiftUI

import TodosBackend
import TodosContract
import TodosFrontend

@main
struct TodosApp: App {
    @State private var todos: [Todo]

    var body: some Scene {
        WindowGroup {
            TodosView(
                todos: todos,
                onAddTodo: handleAddTodo,
                onClearCompleted: handleClearCompleted,
                onDestroyTodo: handleDestroyTodo,
                onToggleAll: handleToggleAll,
                onToggleTodo: handleToggleTodo
            )
        }
    }

    private let addTodo: (AddTodoCommand) -> CommandStatus
    private let clearCompleted: (ClearCompletedCommand) -> CommandStatus
    private let destroyTodo: (DestroyTodoCommand) -> CommandStatus
    private let toggleAll: (ToggleAllCommand) -> CommandStatus
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
        addTodo = createAddTodoCommandHandler(todosRepository: todosRepository)
        clearCompleted = createClearCompletedCommandHandler(todosRepository: todosRepository)
        destroyTodo = createDestroyTodoCommandHandler(todosRepository: todosRepository)
        toggleAll = createToggleAllCommandHandler(todosRepository: todosRepository)
        toggleTodo = createToggleTodoCommandHandler(todosRepository: todosRepository)
        selectTodos = createSelectTodosQueryHandler(todosRepository: todosRepository)

        //
        // Run
        //
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }

    private func handleAddTodo(_ command: AddTodoCommand) {
        _ = addTodo(command)
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }

    private func handleClearCompleted(_ command: ClearCompletedCommand) {
        _ = clearCompleted(command)
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }

    private func handleDestroyTodo(_ command: DestroyTodoCommand) {
        _ = destroyTodo(command)
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }

    private func handleToggleAll(_ command: ToggleAllCommand) {
        _ = toggleAll(command)
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }

    private func handleToggleTodo(_ command: ToggleTodoCommand) {
        _ = toggleTodo(command)
        let result = selectTodos(SelectTodosQuery())
        todos = result.todos
    }
}
