import SwiftUI

import TodosContract

public struct TodosView: View {
    var onClearCompleted: (ClearCompletedCommand) -> Void
    var onDestroyTodo: (DestroyTodoCommand) -> Void
    var onToggleTodo: (ToggleTodoCommand) -> Void

    @State var filter: Filter

    private var todos: [Todo]

    var shownTodos: [Todo] {
        switch filter {
        case .all: return todos
        case .active:
            return todos.filter { e in !e.completed }
        case .completed:
            return todos.filter { e in e.completed }
        }
    }

    var itemsLeft: String {
        let activeCount = todos.filter { e in !e.completed }.count
        return "\(activeCount) \("item".pluralize(count: activeCount)) left"
    }

    var isExistsCompleted: Bool {
        let completedCount = todos.filter { e in e.completed }.count
        return completedCount > 0
    }

    public var body: some View {
        VStack {
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
        }
    }

    public init(
        todos: [Todo] = [],
        filter: Filter = .all,
        onClearCompleted: @escaping (ClearCompletedCommand) -> Void = { _ in },
        onDestroyTodo: @escaping (DestroyTodoCommand) -> Void = { _ in },
        onToggleTodo: @escaping (ToggleTodoCommand) -> Void = { _ in }
    ) {
        self.todos = todos
        self.filter = filter
        self.onClearCompleted = onClearCompleted
        self.onDestroyTodo = onDestroyTodo
        self.onToggleTodo = onToggleTodo
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
                Todo(id: 1, title: "Taste JavaScript", completed: false),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]).previewDisplayName("Multiple active todos")
        }
    }
}
