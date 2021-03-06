//
//  Downloader.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import Foundation


class Downloader {
    
    private let urlSession = URLSession.shared
    
    func fetchNews(fromDate: String, toDate: String, completion: @escaping (Result<NewsResponse, ResponseError>) -> Void) {
        
        guard let url = URLConstructor.createURL(fromDate: fromDate, toDate: toDate) else { return }
        
        let request = URLRequest(url: url)
        
        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.hasSuccessStatusCode,
                  let data = data
            else {
                completion(Result.failure(ResponseError.network))
                return
            }
            
            if let object = try? JSONSerialization.jsonObject(with: data, options: []),
               let dataJSOn = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
               let prettyPrintedString = String(data: dataJSOn, encoding: .utf8) {
                
                print(prettyPrintedString)
            }
            

            
            guard let decodedResponse = try? JSONDecoder().decode(NewsResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            
            completion(Result.success(decodedResponse))
        }).resume()
    }
}


extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
