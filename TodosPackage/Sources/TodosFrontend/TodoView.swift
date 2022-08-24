import SwiftUI

import TodosContract

struct TodoView: View {
    var todo: Todo
    var onDestroy: (Int) -> Void = { _ in }
    var onToggle: (Int) -> Void = { _ in }

    @State private var isMouseHover = false

    var body: some View {
        VStack {
            HStack {
                Button(action: handleToggle) {
                    if todo.completed {
                        Image(systemName: "checkmark.circle").imageScale(.large)
                    } else {
                        Image(systemName: "circle").imageScale(.large)
                    }
                }.buttonStyle(.plain)
                Text(todo.title).strikethrough(todo.completed)
                Spacer()
                if isMouseHover {
                    Button(action: handleDestroy) { Image(systemName: "xmark") }.buttonStyle(.plain)
                }
            }.onHover { over in isMouseHover = over }
            Divider()
        }
    }

    private func handleDestroy() {
        onDestroy(todo.id)
    }

    private func handleToggle() {
        onToggle(todo.id)
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoView(todo: Todo(id: 1, title: "Taste JavaScript", completed: false)).previewDisplayName("active")
            TodoView(todo: Todo(id: 1, title: "Taste JavaScript", completed: true)).previewDisplayName("completed")
        }
    }
}
