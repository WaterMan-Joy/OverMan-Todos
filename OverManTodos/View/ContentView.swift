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
    @State private var showNewTaskItem: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
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
                
                // main view
                VStack(spacing: 20) {
                    
                    // header
                    HStack {
                        // title
                        Text("Over Tasks")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        // edit button
//                        EditButton()
//                            .font(.system(size: 16, weight: .semibold, design: .rounded))
//                            .padding(.horizontal, 10)
//                            .frame(minWidth: 70, minHeight: 24)
//                            .background(Capsule().stroke(Color.white, lineWidth: 2))
                        // apppearance button
                        Button(action: {
                            isDarkMode.toggle()
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        })
                        
                        
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    // current time
                    HStack {
                        
                        // current time
                        RemainTime()
                        
                        // new task button
                        Button(action: {
                            showNewTaskItem = true
                            playSound(sound: "click-sound", type: "mp3")
                            feedback.notificationOccurred(.success)
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                        })
                        .foregroundColor(.pink)
                        .padding()
                        .padding(.vertical, 20)
                        .background(isDarkMode ? .black : .white)
                        .opacity(0.8)
                        .cornerRadius(10)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                    }
                    
                    Spacer(minLength: 20)
                    
                    Spacer()
                    
                    // task list
                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    .frame(maxWidth: 640)
                    .cornerRadius(10)
                    Spacer()
                }
                .blur(radius: showNewTaskItem ? 5.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: 0)
                .padding()
                
                
                // new tasks item
                if showNewTaskItem {
                    BlankView(backgroundColor: isDarkMode ? .black : .gray, backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture() {
                            withAnimation() {
                                showNewTaskItem = false
                                playSound(sound: "click-sound", type: "mp3")
                                feedback.notificationOccurred(.success)
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            }
            .navigationBarTitle("OVERMAN TASKS", displayMode: .large)
            .navigationBarHidden(true)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
            }
            .background(
                BackgroundImageView()
//                    .blur(radius: showNewTaskItem ? 2.0 : 0, opaque: false)
            )
            
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
