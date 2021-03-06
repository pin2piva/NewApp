//
//  Date+String.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import Foundation


extension Date {
    
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
