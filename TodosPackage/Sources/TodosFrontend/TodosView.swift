import SwiftUI

import TodosContract

public struct TodosView: View {
    var onAddTodo: (AddTodoCommand) -> Void
    var onClearCompleted: (ClearCompletedCommand) -> Void
    var onDestroyTodo: (DestroyTodoCommand) -> Void
    var onToggleAll: (ToggleAllCommand) -> Void
    var onToggleTodo: (ToggleTodoCommand) -> Void

    private var todos: [Todo]
    @State private var filter: Filter

    @State private var newTitle = ""

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

    private var itemsLeft: String {
        let activeCount = todos.filter { e in !e.completed }.count
        return "\(activeCount) \("item".pluralize(count: activeCount)) left"
    }

    private var isExistsCompleted: Bool {
        let completedCount = todos.filter { e in e.completed }.count
        return completedCount > 0
    }

    public var body: some View {
        VStack {
            HStack {
                if existsTodo {
                    Button(action: handleToggleAll) {
                        if allCompleted {
                            Image(systemName: "checkmark.circle").imageScale(.large)
                        } else {
                            Image(systemName: "circle").imageScale(.large)
                        }
                    }.buttonStyle(.plain)
                }
                TextField("What needs to be done?", text: $newTitle).onSubmit { handleNewTodo() }
            }.padding(EdgeInsets(top: 10.0, leading: 15.0, bottom: 5.0, trailing: 15.0))
            if existsTodo {
                List(shownTodos) { todo in
                    TodoView(todo: todo, onDestroy: handleDestroy, onToggle: handleToggle)
                }
                HStack {
                    Text(itemsLeft).frame(minWidth: 120, alignment: .leading)
                    Spacer()
                    Picker("", selection: $filter) {
                        Text("All").tag(Filter.all)
                        Text("Active").tag(Filter.active)
                        Text("Completed").tag(Filter.completed)
                    }.pickerStyle(.segmented).frame(width: 270)
                    Spacer()
                    if isExistsCompleted {
                        Button(action: handleClear) { Text("Clear completed") }
                            .frame(minWidth: 120, alignment: .trailing)
                    } else {
                        Button(action: handleClear) { Text("Clear completed") }
                            .frame(minWidth: 120, alignment: .trailing).hidden()
                    }
                }.padding(EdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6))
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

    private func handleNewTodo() {
        let title = newTitle.trimmingCharacters(in: .whitespaces)
        if title.isEmpty {
            return
        }

        onAddTodo(AddTodoCommand(title: newTitle))
        newTitle = ""
    }

    private func handleClear() {
        onClearCompleted(ClearCompletedCommand())
    }

    private func handleDestroy(_ id: Int) {
        onDestroyTodo(DestroyTodoCommand(id: id))
    }

    private func handleToggleAll() {
        onToggleAll(ToggleAllCommand(checked: !allCompleted))
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
