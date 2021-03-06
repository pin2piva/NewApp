//
//  ResponseError.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import Foundation


enum ResponseError: Error, CustomStringConvertible {
    case network
    case decoding
    
    var description: String {
        switch self {
        case .network:
            return "Problem with network"
        case .decoding:
            return "Problem with decoding"
        }
    }
}
