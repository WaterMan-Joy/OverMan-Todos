//
//  OverManTodosApp.swift
//  OverManTodos
//
//  Created by 김종희 on 2023/07/06.
//

import SwiftUI

@main
struct OverManTodosApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
