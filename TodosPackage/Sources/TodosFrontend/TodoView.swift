import Combine
import SwiftUI

import TodosContract

struct TodoView: View {
    var todo: Todo
    var onDestroy: (Int) -> Void = { _ in }
    var onSave: (Int, String) -> Void = { _, _ in }
    var onToggle: (Int) -> Void = { _ in }

    @State private var isMouseHover = false
    @State private var isEditing = false
    @State private var newTitle = ""
    @FocusState private var newTitleIsFocused

    var body: some View {
        VStack {
            if isEditing {
                HStack {
                    Button(action: handleToggle) {
                        Image(systemName: "circle").imageScale(.large)
                    }.buttonStyle(.plain).hidden()
                    // FIXME: todo view triggers message on console:
                    //     Binding<String> action tried to update multiple times per frame.
                    TextField("", text: $newTitle)
                        .focused($newTitleIsFocused)
                        .onSubmit {
                            onSave(todo.id, newTitle)
                            isEditing = false
                        }
                        .onExitCommand(perform: {
                            newTitle = todo.title
                            isEditing = false
                        })
                }
            } else {
                HStack {
                    Button(action: handleToggle) {
                        if todo.completed {
                            Image(systemName: "checkmark.circle").imageScale(.large)
                        } else {
                            Image(systemName: "circle").imageScale(.large)
                        }
                    }.buttonStyle(.plain)
                    Text(todo.title).strikethrough(todo.completed).frame(maxWidth: .infinity, alignment: .leading)
                        .background()
                        .onTapGesture(count: 2, perform: {
                            newTitle = todo.title
                            isEditing = true
                            newTitleIsFocused = true
                        })
                    if isMouseHover {
                        Button(action: handleDestroy) { Image(systemName: "xmark") }.buttonStyle(.plain)
                    }
                }.onHover { over in isMouseHover = over }
            }
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
