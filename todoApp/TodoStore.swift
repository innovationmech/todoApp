import Foundation
import UserNotifications

class TodoStore: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    var incompleteTodos: [TodoItem] {
        todos.filter { !$0.isCompleted }
    }
    
    var completedTodos: [TodoItem] {
        todos.filter { $0.isCompleted }
    }
    
    init() {
        loadTodos()
    }
    
    // 添加这个初始化方法用于预览
    init(previewData: [TodoItem]) {
        self.todos = previewData
    }
    
    func addTodo(title: String, note: String, reminderDate: Date?) {
        let newTodo = TodoItem(title: title, note: note, reminderDate: reminderDate)
        todos.append(newTodo)
        saveTodos()
        
        // 如果设置了提醒时间，创建一个本地通知
        if let reminderDate = reminderDate {
            scheduleNotification(for: newTodo)
        }
    }
    
    func deleteTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    func saveTodos() {
        do {
            let encoded = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(encoded, forKey: "todos")
            print("Saved todos: \(todos)")
        } catch {
            print("Failed to save todos: \(error.localizedDescription)")
        }
    }
    
    private func loadTodos() {
        if let savedTodos = UserDefaults.standard.data(forKey: "todos") {
            do {
                let decodedTodos = try JSONDecoder().decode([TodoItem].self, from: savedTodos)
                DispatchQueue.main.async {
                    self.todos = decodedTodos
                }
                print("Successfully loaded todos: \(decodedTodos)")
            } catch {
                print("Failed to decode todos: \(error.localizedDescription)")
                // 如果解码失败，我们可以尝试清除保存的数据
                UserDefaults.standard.removeObject(forKey: "todos")
            }
        } else {
            print("No saved todos found")
        }
    }
    
    // 添加这个方法来创建本地通知
    private func scheduleNotification(for todo: TodoItem) {
        guard let reminderDate = todo.reminderDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = todo.title
        content.body = todo.note
        content.sound = UNNotificationSound.default  // 修改这一行
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: todo.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func toggleTodoCompletion(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
}