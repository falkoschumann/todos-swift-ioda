import SwiftUI

struct FooterView: View {
    var activeCount: Int
    @Binding var filter: Filter
    var existsCompleted: Bool
    var onClear: () -> Void = {}

    var body: some View {
        HStack {
            Text("\(activeCount) \("item".pluralize(count: activeCount)) left")
                .frame(minWidth: 120, alignment: .leading)
            Spacer()
            Picker("", selection: $filter) {
                Text("All").tag(Filter.all)
                Text("Active").tag(Filter.active)
                Text("Completed").tag(Filter.completed)
            }.pickerStyle(.segmented).frame(width: 270)
            Spacer()
            if existsCompleted {
                Button(action: onClear) { Text("Clear completed") }
                    .frame(minWidth: 120, alignment: .trailing)
            } else {
                Button(action: onClear) { Text("Clear completed") }
                    .frame(minWidth: 120, alignment: .trailing).hidden()
            }
        }.padding(EdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6))
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(activeCount: 0, filter: Binding.constant(.all), existsCompleted: false)
            .previewDisplayName("0 active todos")
        FooterView(activeCount: 1, filter: Binding.constant(.all), existsCompleted: false)
            .previewDisplayName("1 active todo")
        FooterView(activeCount: 2, filter: Binding.constant(.all), existsCompleted: false)
            .previewDisplayName("2 active todos")
        FooterView(activeCount: 0, filter: Binding.constant(.all), existsCompleted: true)
            .previewDisplayName("completed todos exist")
    }
}
