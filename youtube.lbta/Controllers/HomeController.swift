//
//  ViewController.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/22/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
//    var videos: [Video] = {
//        var kanyeChannel = Channel()
//        kanyeChannel.name = "KanyeLaBestChannel"
//        kanyeChannel.profileImageName = "kanye_profile"
//
//        var blankSpace = Video()
//        blankSpace.title = "Taylor Swift - Blank Space"
//        blankSpace.thumbnailImageName = "taylor_swift_blank_space"
//        blankSpace.channel = kanyeChannel
//        blankSpace.numberOfViews = 343433353532
//
//        var badBlood = Video()
//        badBlood.title = "Taylor Swift - Bad Bload Feat. Kanye West"
//        badBlood.thumbnailImageName = "taylor_swift_bad_blood"
//        badBlood.channel = kanyeChannel
//        badBlood.numberOfViews = 3433535323322
//
//        return [blankSpace, badBlood]
//    }()
    
    
    
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
        
        // push the content and scroll bar out from underneath the NavBar
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        setupMenuBar()
        setupNavButtons()
        fetchVideos()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    func fetchVideos() {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                do {
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//                        print(json)
                        self.videos = [Video]()
                        
                        for dictionary in json as! [[String: Any]] {
                            if let video = Video(dictionary: dictionary) {
                                self.videos?.append(video)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
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
    
    lazy var settingLauncher: SettingLauncher = {
        let launch = SettingLauncher()
        launch.homeController = self
        return launch
    } ()
    
    func showControllerForSetting(_ setting: Setting) {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        controller.navigationItem.title = setting.label
        
        navigationController?.navigationBar.tintColor = UIColor.white // back color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white] // title text
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleMore() {
        settingLauncher.showSettings()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.ID, for: indexPath) as! VideoCell
//        cell.thumbnailImageView.image = UIImage(named: videos[indexPath.item].thumbnailImageName!)
        cell.video = videos?[indexPath.item]
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










