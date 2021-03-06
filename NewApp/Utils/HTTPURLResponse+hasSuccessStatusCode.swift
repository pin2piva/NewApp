//
//  HTTPURLResponse+hasSuccessStatusCode.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 6.03.21.
//

import Foundation


extension HTTPURLResponse {
    
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
