//
//  HomeView.swift
//  Restaurant
//
//  Created by Vincenzo Angelone on 08/05/25.
//

import SwiftUI

struct HomeView: View {
    let persistence = PersistenceController.shared

    var body: some View {
        TabView {
            MenuView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
