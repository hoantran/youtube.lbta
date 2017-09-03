//
//  ApiService.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 7/18/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import Foundation

class ApiService {
    static let sharedInstance = ApiService()
    let baseURL = "https://s3-us-west-2.amazonaws.com/youtubeassets"
//    let baseURL = "http://localhost:8000"
    
    func fetchVideos(file: String, completion: @escaping ([Video])->() ) {
        let url = URL(string: "\(self.baseURL)/\(file)")!
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                do {
                    if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        DispatchQueue.main.async {
                            completion(json.map({return Video($0)}))
                        }
                    }
                } catch let jsonError {
                    print("error in JSONSerialization: \(jsonError)")
                }
            } else {
                print(error!.localizedDescription)
                return
            }
        })
        task.resume()
    }
}
