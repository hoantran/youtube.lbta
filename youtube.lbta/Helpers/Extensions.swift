//
//  Extensions.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/27/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraints(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}

let imageCache = NSCache<NSString, UIImage>()

class CustomUIImageView: UIImageView {
    
    var imageStr: String?
    
    func loadImage(urlStr: String) {
        if let cachedImage = imageCache.object(forKey: urlStr as NSString) {
            image = cachedImage
            return
        }
        
        let url = URL(string: urlStr)
        
        image = nil
        imageStr = urlStr
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, responses, error) in
            if error == nil {
                if urlStr == self.imageStr { // make sure to get the right image since this executes asyncly inside a closure
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: urlStr as NSString)
                    DispatchQueue.main.async {
                        self.image = imageToCache
                    }
                }
            } else {
                print(error ?? "some error")
            }
        }).resume()
    }
}
