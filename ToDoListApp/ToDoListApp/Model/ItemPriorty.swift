//
//  ItemPriorty.swift
//  ToDoListApp
//
//  Created by Haven Tracy on 2/25/25.
//

import Foundation

enum ItemPriority : Int, Codable, CaseIterable, Identifiable {
    case low = 0
    case medium = 1
    case high = 2
    var id: Self { self }
}
