//
//  todoAppApp.swift
//  todoApp
//
//  Created by 李燕杰 on 2024/9/13.
//

import SwiftUI
import UserNotifications

@main
struct todoAppApp: App {
    init() {
        requestNotificationAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification authorization granted")
            } else if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }
}
