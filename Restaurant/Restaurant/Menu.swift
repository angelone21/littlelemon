//
//  Menu.swift
//  Restaurant
//
//  Created by Vincenzo Angelone on 07/05/25.
//

import SwiftUI
import CoreData


struct Menu: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Little Lemon")
                .font(.largeTitle)
                .bold()
            Text("Chicago")
                .font(.title2)
            Text("Welcome to our cozy restaurant! We offer the best Mediterranean dishes with fresh ingredients.")
                .font(.body)
            
            List {
                // Future menu items will go here
            }
        }
        .padding()
    }
}

func getMenuData(viewContext: NSManagedObjectContext) {
    PersistenceController.shared.clear()

    let urlString = "https://your-server-url.com/menu.json"
    let url = URL(string: urlString)!
    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            let decoder = JSONDecoder()
            if let decodedMenu = try? decoder.decode(MenuList.self, from: data) {
                DispatchQueue.main.async {
                    for item in decodedMenu.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.image = item.image
                        dish.price = item.price
                        dish.dishDescription = item.description
                        dish.category = item.category
                    }
                    try? viewContext.save()
                }
            }
        }
    }
    task.resume()
}



struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
