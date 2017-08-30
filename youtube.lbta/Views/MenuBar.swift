//
//  MenuBar.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/27/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    let imageNames = ["home", "trending", "subscriptions", "account"]
    let cellID = "cellID"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        
        cell.imageView.image = (UIImage(named: imageNames[indexPath.item]))?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(collectionView)
        addConstraints(format: "H:|[v0]|", views: collectionView)
        addConstraints(format: "V:|[v0]|", views: collectionView)
        
        let selectedPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedPath, animated: false, scrollPosition: .right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    
    let imageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "home")
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor =  isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor =  isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        
        addConstraints(format: "H:[v0(28)]", views: imageView)
        addConstraints(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
