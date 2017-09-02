//
//  Video.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/27/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        if self.responds(to: NSSelectorFromString(key)) {
            super.setValue(value, forKey: key)
        }
    }
    
    init(_ dictionary: [String: Any]){
        super.init()
        setValuesForKeys(dictionary)
    };
}

class Video: SafeJsonObject {
    
    @objc var thumbnail_image_name: String?
    @objc var title: String?
    @objc var number_of_views: NSNumber?
    @objc var uploadDate: NSDate?
    @objc var duration: NSNumber?
    
    @objc var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) { 
        if key == "channel" {
            self.channel = Channel(value as! [String: Any])
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override init(_ dictionary: [String: Any]) {
        super.init(dictionary)
        setValuesForKeys(dictionary)
    }
    
}

class Channel: SafeJsonObject {
    @objc var name: String?
    @objc var profile_image_name: String?
}




















//
//
//extension NSObject {
//    func safeValue(forKey key: String) -> Any? {
//        let copy = Mirror(reflecting: self)
//
//        copy.children.makeIterator().map { (label: String?, value: Any) in
//            print("\(label): \(value)")
//        }
//        for child in copy.children.makeIterator() {
//            if let label = child.label, label == key {
//                return "yes"
//            }
//        }
//        return nil
//    }
//}
//
//class Video: NSObject {
//    var thumbnail_image_name: String?
//    var title: String?
//    var number_of_views: NSNumber?
//    var uploadDate: NSDate?
//
//    var channel: Channel?
//
//    override func setValue(_ value: Any?, forKey key: String) {
//        print(key)
//        print(value ?? "x")
//        print(self.safeValue(forKey: "what") ?? "")
//        print(self.safeValue(forKey: key) ?? "")
//        print(self.safeValue(forKey: "thumbnail_image_name") ?? "")
//
//
//        print("hey")
//    }
//
////    init?(dictionary: [String: Any]) {
////        guard let title = dictionary["title"] as? String else { return nil }
////        self.title = title
////
////        guard let thumbnail = dictionary["thumbnail_image_name"] as? String else { return nil }
////        self.thumbnailImageName = thumbnail
////
////        guard let channelDictionary = dictionary["channel"] as? [String: Any] else { return nil }
////        channel = Channel()
////        channel?.name = channelDictionary["name"] as? String
////        channel?.profileImageName = channelDictionary["profile_image_name"] as? String
////
////        let numberOfViews = dictionary["number_of_views"] as? NSNumber
////        guard let nViews = numberOfViews else { return nil }
////        self.numberOfViews = NSNumber(value: nViews.intValue)
////    }
//}
//
//
//class Channel: NSObject {
//    var name: String?
//    var profileImageName: String?
//}

//// -----------------------

//class SafeJsonObject: NSObject {
//    override func setValue(_ value: Any?, forKey key: String) {
//        let upperCaseFirstCharacter = String(key.characters.first!).uppercased()
//        let range = key.startIndex..<key.index(key.startIndex, offsetBy: 1)
//        let selectorString = key.replacingCharacters(in: range, with: upperCaseFirstCharacter)
//
//        let selector = NSSelectorFromString("set\(selectorString):")
//        print(self.responds(to: NSSelectorFromString("\(key):")))
//        let responds = self.responds(to: selector)
//
//        if !responds{
//            return
//        }
//        super.setValue(value, forKey: key)
//    }
//
//    init(_ dictionary: [String: Any]){
//        super.init()
//        setValuesForKeys(dictionary)
//    };
//}
//
//class Video: SafeJsonObject {
//
//    var thumbnail_image_name: String?
//    var title: String?
//    var number_of_views: NSNumber?
//    var uploadDate: NSDate?
//    var duration: NSNumber?
//
//    var channel: Channel?
//
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "channel" {
//            self.channel = Channel(value as! [String: Any])
//        } else {
//            super.setValue(value, forKey: key)
//        }
//    }
//
//    init(dictionary: [String: Any]) {
//        super.init(dictionary)
//        setValuesForKeys(dictionary)
//    }
//
//}
//
//class Channel: SafeJsonObject {
//    var name: String?
//    var profile_image_name: String?
//}

