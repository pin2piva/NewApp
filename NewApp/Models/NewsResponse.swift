//
//  NewsResponse.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import Foundation


struct NewsResponse: Decodable {
    let status: String
    let articles: [Article]
    let totalResults: Int
}
