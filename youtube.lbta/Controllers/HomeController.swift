//
//  ViewController.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/22/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video] = {
        var kanyeChannel = Channel()
        kanyeChannel.name = "KanyeLaBestChannel"
        kanyeChannel.profileImageName = "kanye_profile"
        
        var blankSpace = Video()
        blankSpace.title = "Taylor Swift - Blank Space"
        blankSpace.thumbnailImageName = "taylor_swift_blank_space"
        blankSpace.channel = kanyeChannel
        blankSpace.numberOfViews = 343433353532
        
        var badBlood = Video()
        badBlood.title = "Taylor Swift - Bad Bload Feat. Kanye West"
        badBlood.thumbnailImageName = "taylor_swift_bad_blood"
        badBlood.channel = kanyeChannel
        badBlood.numberOfViews = 3433535323322
        
        return [blankSpace, badBlood]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Home"
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width-32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.ID)
        UINavigationBar.appearance().tintColor = UIColor.red
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        setupMenuBar()
        setupNavButtons()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraints(format: "H:|[v0]|", views: menuBar)
        view.addConstraints(format: "V:|[v0(50)]", views: menuBar)
    }
    
    private func setupNavButtons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc
    func handleSearch(){
        print("hi")
    }
    
    @objc func handleMore() {
        print(123)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.ID, for: indexPath) as! VideoCell
//        cell.thumbnailImageView.image = UIImage(named: videos[indexPath.item].thumbnailImageName!)
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}










