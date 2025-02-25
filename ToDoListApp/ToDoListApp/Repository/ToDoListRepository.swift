//
//  ToDoListRepository.swift
//  ToDoListApp
//
//  Created by Haven Tracy on 2/25/25.
//

import Foundation
import SwiftUI

protocol ToDoListRepository {
    func saveToDoItems(_ toDoItems: [ToDoItem])
    func loadToDoItems() -> [ToDoItem]
}

class ToDoListRepositoryImpl: ToDoListRepository {
    @AppStorage("toDoItems") private var toDoItemsData: Data = Data()

    func saveToDoItems(_ toDoItems: [ToDoItem]) {
        do {
            let data = try JSONEncoder().encode(toDoItems)
            UserDefaults.standard.set(data, forKey: "toDoItems")
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func loadToDoItems() -> [ToDoItem] {
        if let data = UserDefaults.standard.data(forKey: "toDoItems") {
            do {
              return try JSONDecoder().decode([ToDoItem].self, from: toDoItemsData)
            } catch {
                print("Error loading data: \(error)")
            }
        }
       return []
    }
    
}
