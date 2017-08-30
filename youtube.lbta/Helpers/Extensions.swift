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

extension UIImageView {
    func loadImage(url: String) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, responses, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            } else {
                print(error ?? "some error")
            }
        }).resume()
    }
}
