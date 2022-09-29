//
//  MySMSBlockerApp.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 9/29/22.
//

import SwiftUI

@main
struct MySMSBlockerApp: App {
    let persistenceController = CloudKitPersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
