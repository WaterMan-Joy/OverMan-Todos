//
//  ContentView.swift
//  OverManTodos
//
//  Created by 김종희 on 2023/07/06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyBoadrd()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // new task and button
                    VStack(spacing: 16, content: {
                        TextField("NEW TASK", text: $task)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        Button(action: {
                            print("save click")
                            addItem()
                        }, label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        })
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.gray : Color.pink)
                        .cornerRadius(10)
                        
                        // task list
                        List {
                            ForEach(items) { item in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(item.task ?? "")")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("\(item.timestamp!, formatter: itemFormatter)")
                                        .font(.footnote)
                                    .foregroundColor(.gray)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .opacity(0.9)
                        .cornerRadius(10)
                        .frame(maxWidth: 640)
                    }) //: VSTACK
                    .padding()
                    
                }
            }
            .navigationBarTitle("OVERMAN TASKS", displayMode: .large)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
            }
            .background(BackgroundImageView())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    
}



// preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
