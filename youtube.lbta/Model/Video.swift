//
//  Video.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/27/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class Video: NSObject {
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
    
    init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String else { return nil }
        self.title = title
        
        guard let thumbnail = dictionary["thumbnail_image_name"] as? String else { return nil }
        self.thumbnailImageName = thumbnail
        
        guard let channelDictionary = dictionary["channel"] as? [String: Any] else { return nil }
        channel = Channel()
        channel?.name = channelDictionary["name"] as? String
        channel?.profileImageName = channelDictionary["profile_image_name"] as? String
        
        let numberOfViews = dictionary["number_of_views"] as? NSNumber
        guard let nViews = numberOfViews else { return nil }
        self.numberOfViews = NSNumber(value: nViews.intValue)
    }
}


class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
