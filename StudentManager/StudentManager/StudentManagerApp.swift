//
//  StudentManagerApp.swift
//  StudentManager
//
//  Created by ddukk15 on 04/11/25.
//

import SwiftUI

@main
struct StudentManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
