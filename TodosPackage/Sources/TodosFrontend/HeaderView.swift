import SwiftUI

struct HeaderView: View {
    var existsTodo: Bool
    var allCompleted: Bool
    var onAddTodo: (String) -> Void = { _ in }
    var onToggleAll: (Bool) -> Void = { _ in }

    @State private var newTitle = ""

    private var toggleAllImage: String {
        if allCompleted {
            return "checkmark.circle"
        } else {
            return "circle"
        }
    }

    var body: some View {
        HStack {
            if existsTodo {
                Button(action: handleToggleAll) {
                    Image(systemName: toggleAllImage).imageScale(.large)
                }.buttonStyle(.plain)
            } else {
                Button(action: handleToggleAll) {
                    Image(systemName: toggleAllImage).imageScale(.large)
                }.buttonStyle(.plain).hidden()
            }
            TextField("What needs to be done?", text: $newTitle).onSubmit { handleNewTodo() }
        }.padding(EdgeInsets(top: 10.0, leading: 15.0, bottom: 5.0, trailing: 15.0))
    }

    private func handleToggleAll() {
        onToggleAll(!allCompleted)
    }

    private func handleNewTodo() {
        let title = newTitle.trimmingCharacters(in: .whitespaces)
        if title.isEmpty {
            return
        }

        onAddTodo(title)
        newTitle = ""
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(existsTodo: false, allCompleted: false).previewDisplayName("no todos exist")
        HeaderView(existsTodo: true, allCompleted: false).previewDisplayName("todos exist")
    }
}
