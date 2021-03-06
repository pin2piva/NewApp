//
//  Article.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import Foundation


struct Article: Decodable {
    let source: ArticleSource
    let author: String?
    let urlToImage: String?
    let content: String?
    let title: String
    let publishedAt: String
    let description: String
    let url: String
}
