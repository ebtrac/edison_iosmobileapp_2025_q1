//
//  ToDoListViewModel.swift
//  ToDoListApp
//
//  Created by Haven Tracy on 2/25/25.
//

import Foundation
import SwiftUI
import Combine

class ToDoListViewModel: ObservableObject {
    
    private let repository: ToDoListRepository = ToDoListRepositoryImpl()
    
    @Published var editingItemId: UUID? = nil
    @Published var inputTask: String = ""
    @Published var toDoItems: [ToDoItem] = []
    @Published var selectedPriority: ItemPriority = .low
    
    func addItem() {
        if inputTask.isEmpty { return }
        toDoItems.append(ToDoItem(title: inputTask, priority: selectedPriority))
        inputTask = ""
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
            repository.saveToDoItems(toDoItems)
        }
    }
    
    func onSubmit() {
        editingItemId = nil
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
}

