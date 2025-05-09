//
//  MenuView.swift
//  Restaurant
//
//  Created by Vincenzo Angelone on 08/05/25.
//

import SwiftUI
import CoreData

struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText: String = ""
    @State private var selectedCategory: String?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search menu", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["Starters", "Mains", "Desserts", "Drinks"], id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding(8)
                                    .background(selectedCategory == category ? Color.green : Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }.padding(.horizontal)
                }

                FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List {
                        ForEach(dishes) { dish in
                            NavigationLink(destination: DishDetailView(dish: dish)) {
                                HStack {
                                    Text("\(dish.title ?? "") - $\(dish.price ?? "")")
                                    Spacer()
                                    if let urlString = dish.image, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Menu")
            }
        }
        .onAppear {
            getMenuData(viewContext: viewContext)
        }

    }

    func getMenuData(viewContext: NSManagedObjectContext) {
        PersistenceController.shared.clear()

        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
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

    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        ]
    }

    func buildPredicate() -> NSPredicate {
        var predicates: [NSPredicate] = []

        if let category = selectedCategory, !category.isEmpty {
            predicates.append(NSPredicate(format: "category ==[cd] %@", category))
        }

        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }

        if predicates.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
}
