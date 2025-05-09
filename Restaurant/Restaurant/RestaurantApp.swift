//
//  RestaurantApp.swift
//  Restaurant
//
//  Created by Vincenzo Angelone on 07/05/25.
//

import SwiftUI

@main
struct RestaurantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
