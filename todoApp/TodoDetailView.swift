import SwiftUI

struct TodoDetailView: View {
    @Binding var todo: TodoItem
    var saveTodos: () -> Void

    var body: some View {
        Form {
            TextField("标题", text: $todo.title)
            TextField("备注", text: $todo.note)
            Toggle("已完成", isOn: $todo.isCompleted)
        }
        .navigationTitle("编辑待办事项")
        #if compiler(>=5.9) && canImport(SwiftUI)
        .onChange(of: todo) { 
            saveTodos()
        }
        #else
        .onChange(of: todo) { _ in
            saveTodos()
        }
        #endif
    }
}