//
//  SettingsLauncher.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 7/12/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class SettingLauncher {
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    @objc func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height:CGFloat = 200
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x:0, y:y, width:self.collectionView.frame.width, height:self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x:0, y:window.frame.height, width:self.collectionView.frame.width, height:self.collectionView.frame.height)
            }
            
        })
    }
}
