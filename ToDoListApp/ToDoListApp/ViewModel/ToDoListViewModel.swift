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
    
    func addItem() {
        if inputTask.isEmpty { return }
        toDoItems.append(ToDoItem(title: inputTask))
        inputTask = ""
        repository.saveToDoItems(toDoItems)
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
    }
}

