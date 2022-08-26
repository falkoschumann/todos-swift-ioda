import SwiftUI

import TodosContract

public struct TodosView: View {
    private let todos: [Todo]
    @State private var filter: Filter
    private let onAddTodo: (AddTodoCommand) -> Void
    private let onClearCompleted: (ClearCompletedCommand) -> Void
    private let onDestroyTodo: (DestroyTodoCommand) -> Void
    private let onToggleAll: (ToggleAllCommand) -> Void
    private let onToggleTodo: (ToggleTodoCommand) -> Void

    private var existsTodo: Bool {
        !todos.isEmpty
    }

    private var allCompleted: Bool {
        let completedCount = todos.filter { e in e.completed }.count
        return completedCount == todos.count
    }

    private var shownTodos: [Todo] {
        switch filter {
        case .all: return todos
        case .active:
            return todos.filter { e in !e.completed }
        case .completed:
            return todos.filter { e in e.completed }
        }
    }

    private var activeCount: Int {
        todos.filter { e in !e.completed }.count
    }

    private var existsCompleted: Bool {
        let completedCount = todos.filter { e in e.completed }.count
        return completedCount > 0
    }

    public var body: some View {
        VStack {
            HeaderView(
                existsTodo: existsTodo,
                allCompleted: allCompleted,
                onAddTodo: handleAddTodo,
                onToggleAll: handleToggleAll
            )
            if existsTodo {
                List(shownTodos) { todo in
                    TodoView(todo: todo, onDestroy: handleDestroy, onToggle: handleToggle)
                }
                FooterView(
                    activeCount: activeCount,
                    filter: $filter,
                    existsCompleted: existsCompleted,
                    onClear: handleClear
                )
            } else {
                Spacer()
            }
        }.frame(minHeight: 400)
    }

    public init(
        todos: [Todo] = [],
        filter: Filter = .all,
        onAddTodo: @escaping (AddTodoCommand) -> Void = { _ in },
        onClearCompleted: @escaping (ClearCompletedCommand) -> Void = { _ in },
        onDestroyTodo: @escaping (DestroyTodoCommand) -> Void = { _ in },
        onToggleAll: @escaping (ToggleAllCommand) -> Void = { _ in },
        onToggleTodo: @escaping (ToggleTodoCommand) -> Void = { _ in }
    ) {
        self.todos = todos
        self.filter = filter
        self.onAddTodo = onAddTodo
        self.onClearCompleted = onClearCompleted
        self.onDestroyTodo = onDestroyTodo
        self.onToggleAll = onToggleAll
        self.onToggleTodo = onToggleTodo
    }

    private func handleToggleAll(checked: Bool) {
        onToggleAll(ToggleAllCommand(checked: checked))
    }

    private func handleAddTodo(title: String) {
        onAddTodo(AddTodoCommand(title: title))
    }

    private func handleClear() {
        onClearCompleted(ClearCompletedCommand())
    }

    private func handleDestroy(_ id: Int) {
        onDestroyTodo(DestroyTodoCommand(id: id))
    }

    private func handleToggle(_ id: Int) {
        onToggleTodo(ToggleTodoCommand(id: id))
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodosView().previewDisplayName("Empty")
            TodosView(todos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]).previewDisplayName("All todos")
            TodosView(
                todos: [
                    Todo(id: 1, title: "Taste JavaScript", completed: true),
                    Todo(id: 2, title: "Buy Unicorn", completed: false),
                ],
                filter: .active
            ).previewDisplayName("Active todos")
            TodosView(
                todos: [
                    Todo(id: 1, title: "Taste JavaScript", completed: true),
                    Todo(id: 2, title: "Buy Unicorn", completed: false),
                ],
                filter: .completed
            ).previewDisplayName("Completed todos")
            TodosView(todos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: true),
            ]).previewDisplayName("All todos completed")
            TodosView(todos: [
                Todo(id: 1, title: "Taste JavaScript", completed: false),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]).previewDisplayName("All todos active")
        }
    }
}
