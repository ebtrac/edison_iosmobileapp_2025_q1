//
//  ToDoListViewModel.swift
//  ToDoListApp
//
//  Created by Haven Tracy on 2/25/25.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

class ToDoListViewModel: ObservableObject {
    
    private let repository: ToDoListRepository = ToDoListRepositoryImpl()
    
    @Published var editingItemId: UUID? = nil
    @Published var inputTask: String = ""
    @Published var inputTags: String = ""
    @Published var toDoItems: [ToDoItem] = []
    @Published var selectedPriority: ItemPriority = .low
    @Published var searchText: String = ""
    @Published var selectedTime: Date = Date()
    @Published var isNotificationEnabled: Bool = false
    
    
    func addItem() {
        if inputTask.isEmpty { return }
        let newItem = ToDoItem(
            title: inputTask,
            priority: selectedPriority,
            dueDate: isNotificationEnabled ? selectedTime : nil,
            tags: parseTags(inputTags)
        )
        toDoItems.append(newItem)
        if(isNotificationEnabled) {
            Task {
                await scheduleNotification(at: selectedTime, with: newItem)
            }
        }
        inputTask = ""
        inputTags = ""
        sortByPriority()
        repository.saveToDoItems(toDoItems)
    }
    
   
    
    func sortByPriority() {
        toDoItems.sort { (item1, item2) -> Bool in
            switch (item1.priority, item2.priority) {
            case (.low, .high):
                fallthrough
            case (.low, .medium):
                fallthrough
            case (.medium, .high):
                return false
                
            case (.high, .low):
                fallthrough
            case (.high, .medium):
                fallthrough
            case(.medium, .low):
                return true
                
            default:
                return item1.title < item2.title
            }
        }
    }
    
    func removeItem(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            let item = toDoItems[index]
            if item.dueDate != nil {
                removeNotification(uuid:item.id)
            }
            toDoItems.remove(at: index)
            repository.saveToDoItems(toDoItems)
        }
    }
    
    func toggleItem(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isComplete.toggle()
            repository.saveToDoItems(toDoItems)
        }
    }
    
    func updateItemText(_ item: ToDoItem, _ newValue: String) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].title = newValue
            sortByPriority()
            repository.saveToDoItems(toDoItems)
        }
    }
    
    func parseTags(_ input: String) -> [String] {
        input.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    func itemMatchesSearchQuery(_ item: ToDoItem) -> Bool {
        if searchText.isEmpty { return true }
        if item.title.localizedStandardRange(of: searchText) != nil {
            return true
        } else {
            return false
        }
    }
    
    func onSubmit() {
        editingItemId = nil
        inputTags = ""
        repository.saveToDoItems(toDoItems)
    }
    
    func onTapItem(_ item: ToDoItem) {
        editingItemId = item.id
        repository.saveToDoItems(toDoItems)
    }
    
    func loadData() {
        toDoItems = repository.loadToDoItems()
        sortByPriority()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error)")
            }
        }
    }

    func scheduleNotification(at date: Date, with item: ToDoItem) async {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        let content = UNMutableNotificationContent()
        content.title = "ToDoList Reminder"
        content.body = item.title
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
            
        do {
            try await notificationCenter.add(request)
        } catch {
            print("NOOOOO")
        }
    }
    
    func removeNotification(uuid:UUID) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [uuid.uuidString])
    }
}

