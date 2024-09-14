import SwiftUI

struct AddTodoView: View {
    @Binding var isPresented: Bool
    let addTodo: (String, String, Date?) -> Void
    @State private var title = ""
    @State private var note = ""
    @State private var reminderDate: Date?
    @State private var isReminderEnabled = false

    var body: some View {
        NavigationView {
            Form {
                TextField("提醒事项", text: $title)
                TextField("备注", text: $note)
                
                Toggle("设置提醒时间", isOn: $isReminderEnabled.animation())
                
                if isReminderEnabled {
                    DatePicker("提醒时间", selection: Binding(
                        get: { self.reminderDate ?? Date() },
                        set: { self.reminderDate = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("新建提醒事项")
            .navigationBarItems(
                leading: Button("取消") {
                    isPresented = false
                },
                trailing: Button("添加") {
                    addTodo(title, note, isReminderEnabled ? reminderDate : nil)
                    isPresented = false
                }
            )
        }
    }
}