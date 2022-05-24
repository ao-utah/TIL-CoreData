//
//  TIL_CoreDataApp.swift
//  TIL-CoreData
//
//  Created by 青木雄太 on 2022/05/24.
//

import SwiftUI

@main
struct TIL_CoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
