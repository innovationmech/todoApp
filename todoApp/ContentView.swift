//
//  ContentView.swift
//  todoApp
//
//  Created by 李燕杰 on 2024/9/13.
//

import SwiftUI

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

struct ContentView: View {
    @StateObject private var todoStore = TodoStore()
    @State private var isShowingAddDialog = false
    @State private var errorMessage: ErrorMessage?
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TodoListView(todos: todoStore.incompleteTodos, todoStore: todoStore)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("待办事项")
                }
                .tag(0)
            
            CompletedTodoListView(todos: todoStore.completedTodos, todoStore: todoStore)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("已完成")
                }
                .tag(1)
        }
        .sheet(isPresented: $isShowingAddDialog) {
            AddTodoView(isPresented: $isShowingAddDialog, addTodo: todoStore.addTodo)
        }
        .alert(item: $errorMessage) { error in
            Alert(title: Text("错误"), message: Text(error.message), dismissButton: .default(Text("确定")))
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    isShowingAddDialog = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30)
            }
        )
    }
}

struct TodoListView: View {
    let todos: [TodoItem]
    let todoStore: TodoStore

    var body: some View {
        NavigationView {
            List {
                if todos.isEmpty {
                    Text("没有待办事项")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(todos) { todo in
                        TodoRowView(todoStore: todoStore, todo: todo)
                    }
                    .onDelete(perform: todoStore.deleteTodos)
                }
            }
            .navigationTitle("待办事项")
        }
    }
}

struct CompletedTodoListView: View {
    let todos: [TodoItem]
    let todoStore: TodoStore

    var body: some View {
        NavigationView {
            List {
                if todos.isEmpty {
                    Text("没有已完成事项")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(todos) { todo in
                        TodoRowView(todoStore: todoStore, todo: todo)
                    }
                    .onDelete(perform: todoStore.deleteTodos)
                }
            }
            .navigationTitle("已完成事项")
        }
    }
}

struct TodoRowView: View {
    @ObservedObject var todoStore: TodoStore
    let todo: TodoItem

    var body: some View {
        NavigationLink(destination: TodoDetailView(todo: Binding(
            get: { self.todo },
            set: { newValue in
                if let index = self.todoStore.todos.firstIndex(where: { $0.id == self.todo.id }) {
                    self.todoStore.todos[index] = newValue
                    self.todoStore.saveTodos()
                }
            }
        ), saveTodos: todoStore.saveTodos)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(todo.title)
                        .font(.headline)
                        .strikethrough(todo.isCompleted)
                    if !todo.note.isEmpty {
                        Text(todo.note)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    if let reminderDate = todo.reminderDate {
                        Text(formatDate(reminderDate))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                if todo.isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
        }
        .swipeActions(edge: .leading) {
            Button(action: {
                todoStore.toggleTodoCompletion(todo)
            }) {
                Label(todo.isCompleted ? "标记未完成" : "标记完成", systemImage: todo.isCompleted ? "xmark.circle" : "checkmark.circle")
            }
            .tint(todo.isCompleted ? .orange : .green)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}

