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
    
    func fetchVideos(completion: @escaping ([Video])->() ) {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                do {
                    var videos = [Video]()
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        
                        for dictionary in json as! [[String: Any]] {
                            if let video = Video(dictionary: dictionary) {
                                videos.append(video)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        completion(videos)
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
