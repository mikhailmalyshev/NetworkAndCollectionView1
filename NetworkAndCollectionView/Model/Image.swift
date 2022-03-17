//
//  Image.swift
//  NetworkAndCollectionView
//
//  Created by Михаил Малышев on 15.03.2022.
//

import Foundation

struct Image: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let small: String
    let regular: String
}
