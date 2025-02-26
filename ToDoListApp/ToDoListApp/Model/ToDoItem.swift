//
//  ToDoItem.swift
//  ToDoListApp
//
//  Created by Haven Tracy on 2/25/25.
//

import Foundation

struct ToDoItem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var isComplete: Bool = false
    var priority: ItemPriority = .low
    var dueDate: Date?
    var tags: [String] = []
}
