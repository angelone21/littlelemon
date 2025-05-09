//
//  DishDetailView.swift
//  Restaurant
//
//  Created by Vincenzo Angelone on 08/05/25.
//

import SwiftUI

struct DishDetailView: View {
    var dish: Dish

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = URL(string: dish.image ?? "") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                    .clipped()
                }

                Text(dish.title ?? "")
                    .font(.largeTitle)
                    .bold()
                Text("Price: $\(dish.price ?? "")")
                    .font(.title2)
                Text(dish.dishDescription ?? "")
                    .font(.body)
                Spacer()
            }
            .padding()
        }
    }
}
