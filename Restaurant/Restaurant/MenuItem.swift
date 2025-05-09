//
//  MenuItem.swift
//  Restaurant
//
//  Created by Vincenzo Angelone on 08/05/25.
//

import Foundation

struct MenuItem: Decodable {
    let title: String
    let image: String
    let price: String
    let description: String?
    let category: String?
}


