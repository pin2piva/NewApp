//
//  URLConstructor.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import Foundation


class URLConstructor {
    
    private static let apiKey = "0363a0902c1d4ecb8d959d30a1452c46"
    
    
    static func createURL(fromDate: String, toDate: String) -> URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/everything"
        components.queryItems = [
            URLQueryItem(name: "q", value: "us"),
            URLQueryItem(name: "from", value: fromDate),
            URLQueryItem(name: "to", value: toDate),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]

        return components.url
    }
}
