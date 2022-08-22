import SwiftUI

import TodosContract

public struct TodosView: View {
    private var todos: [Todo]
    @State var filter: Filter

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

    public var body: some View {
        VStack {
            List(shownTodos, id: \.id) { todo in
                HStack {
                    Toggle("", isOn: Binding.constant(todo.completed)).toggleStyle(.checkbox)
                    Text(todo.title)
                }
                Divider()
            }
            HStack {
                Text(itemsLeft)
                Spacer()
                Picker("", selection: $filter) {
                    Text("All").tag(Filter.all)
                    Text("Active").tag(Filter.active)
                    Text("Completed").tag(Filter.completed)
                }.pickerStyle(.segmented).frame(width: 270)
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6))
        }
    }

    public init(todos: [Todo] = [], filter: Filter = .all) {
        self.todos = todos
        self.filter = filter
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
            ]).previewDisplayName("All active")
        }
    }
}
