//
//  ViewController.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 6/22/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupNavBarAppearance()
        setupCollectionView()
        setupMenuBar()
        setupNavButtons()
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width-32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
    }
    
    private func setupNavBarAppearance(){
        collectionView?.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.red
    }
    
    private func setupCollectionView() {
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: self.cellID)
        // push the content and scroll bar out from underneath the NavBar
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        collectionView?.isPagingEnabled = true
    }
    
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        // hide the sliding collection view cells underneath
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraints(format: "H:|[v0]|", views: redView)
        view.addConstraints(format: "V:|[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraints(format: "H:|[v0]|", views: menuBar)
        
        view.addConstraints(format: "V:[v0(50)]", views: menuBar) // make sure there's no vertical bar at the top, otherwise the menubar will go into the status area
        
        // https://useyourloaf.com/blog/safe-area-layout-guide/
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            menuBar.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true // helps stops menu bar from going underneath the status area ontop of screen
        } else {
            menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true // helps stops menu bar from going underneath the status area ontop of screen
        }
    }
    
    private func setupNavButtons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc func handleSearch(){
        scrollToMenuIndex(menuIndex: 2)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setNavigationItem(menuIndex)
    }
    
    func setNavigationItem(_ index: Int) {
        if index < MenuBar.ITEMS.count {
            if let titleLabel = navigationItem.titleView as? UILabel {
                titleLabel.text = "  \(MenuBar.ITEMS[index].title)"
            }
        }
    }
    
    lazy var settingLauncher: SettingLauncher = {
        let launch = SettingLauncher()
        launch.homeController = self
        return launch
    } ()
    
    func showControllerForSetting(_ setting: Setting) {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        controller.navigationItem.title = setting.label.rawValue
        
        navigationController?.navigationBar.tintColor = UIColor.white // back color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white] // title text// NSAttributedString.foregroundColor.rawValue: UIColor.white] // title text
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleMore() {
        settingLauncher.showSettings()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        setNavigationItem(Int(index))
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }

}










