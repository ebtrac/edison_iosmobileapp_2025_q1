//
//  ItemPriorty.swift
//  ToDoListApp
//
//  Created by Haven Tracy on 2/25/25.
//

import Foundation

enum ItemPriority : String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    var id: Self { self }
}
