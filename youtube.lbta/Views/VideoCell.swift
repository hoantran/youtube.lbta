//
//  VideoCell.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/27/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){}
}

class VideoCell: BaseCell {
    static let ID = "videoCellID"
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
            setupThumbnailImage()
            setupProfileImage()
            
            if let profileImageName = video?.channel?.profileImageName {
                userProfileView.image = UIImage(named: profileImageName)
            }
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let subtitleText = "\(channelName) - \(numberFormatter.string(from: numberOfViews) ?? "0")) - 2 years ago"
                subTitleTextView.text = subtitleText
            }
            
            // guess title text size
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with:size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
                
                if estimatedRect.size.height > 18 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1 )
        return view
    } ()
    
    let userProfileView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "taylor_swift_profile")
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    } ()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Taylor Swift - Blank Space"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    } ()
    
    let subTitleTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Taylor SwiftVevo -------- 1,609,343 views - 2 years ago"
        view.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        view.textColor = UIColor.lightGray
        return view
    } ()
    
    var titleLabelHeightConstraint:NSLayoutConstraint?
    
    func setupThumbnailImage() {
         if let imageURL = video?.thumbnailImageName {
            thumbnailImageView.loadImage(url: imageURL)
        }
    }
    
    func setupProfileImage() {
        if let imageURL = video?.channel?.profileImageName {
            userProfileView.loadImage(url: imageURL)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileView)
        addSubview(titleLabel)
        addSubview(subTitleTextView)
        
        addConstraints(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraints(format: "H:|[v0]|", views: separatorView)
        addConstraints(format: "H:|-16-[v0(44)]", views: userProfileView)
        
        addConstraints(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileView, separatorView)
        
        // titleLabel
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20)
        addConstraint(titleLabelHeightConstraint!)
        
        // subtitleTextView
        addConstraint(NSLayoutConstraint(item: subTitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: subTitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subTitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subTitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}
