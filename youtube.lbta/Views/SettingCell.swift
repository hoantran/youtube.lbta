//
//  SettingCell.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 7/12/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class Setting {
    let label: String
    let image: String
    
    init(label: String, image: String) {
        self.label = label
        self.image = image
    }
}


class SettingCell: BaseCell {
    static let cellID = "settingCellID"
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = self.isHighlighted ? UIColor.darkGray : UIColor.white
            labelView.textColor = self.isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = self.isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            labelView.text = setting?.label
            if let imageName = setting?.image {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    let labelView: UILabel = {
        let view = UILabel()
        view.text = "Setting"
        view.font = UIFont.systemFont(ofSize: 13)
        return view
    }()
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "settings")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(labelView)
        addSubview(iconImageView)
        
        addConstraints(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, labelView)
        addConstraints(format: "V:|[v0]|", views: labelView)
        addConstraints(format: "V:[v0(30)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
