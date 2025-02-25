//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Haven Tracy on 2/25/25.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = ToDoListViewModel()
    @State private var selectedPriority: ItemPriority = .medium
    
    var body: some View {
        VStack {
            HStack {
                TextField("Input Task", text: $viewModel.inputTask)
                Button("Add") {
                    viewModel.addItem()
                }
            }
            .padding([.leading, .trailing, .bottom], 15)
            .background(Color.blue.opacity(0.2))
            
            HStack {
                Text("Priority")
                Spacer()
                Picker("Priority", selection: $selectedPriority) {
                    ForEach(ItemPriority.allCases) { priority in
                        Text(priority.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            .padding([.leading, .trailing, .bottom], 15)
            .background(Color.blue.opacity(0.2))
            
            List {
                ForEach(viewModel.toDoItems) { item in
                    HStack {
                        Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                viewModel.toggleItem(item)
                            }
                        if viewModel.editingItemId == item.id {
                            TextField("", text: Binding(
                                get: { item.title },
                                set: { newValue in
                                    viewModel.updateItemText(item, newValue)
                                }
                            ))
                            .onSubmit {
                                viewModel.onSubmit()
                            }
                        }
                        else {
                            Text(item.title)
                                .strikethrough(item.isComplete)
                                .onTapGesture {
                                    viewModel.onTapItem(item)
                                }
                        }
                        
                        Spacer()
                        Button {
                            viewModel.removeItem(item)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            
            Spacer()
        }
        .onAppear() {
            viewModel.loadData()
        }
    }
}

#Preview {
    ContentView()
}
