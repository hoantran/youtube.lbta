//
//  VideoLauncher.swift
//  youtube.lbta
//
//  Created by Hoan Tran on 9/3/17.
//  Copyright © 2017 Pego Consulting. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    var player: AVPlayer?
    var isPlaying: Bool = false
    var pauseButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.white
        b.setImage(UIImage(named: "pause"  ), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    
    @objc func handlePause() {
        if self.isPlaying {
            self.pauseButton.setImage(UIImage(named: "play"  ), for: .normal)
            self.player?.pause()
        } else {
            self.pauseButton.setImage(UIImage(named: "pause" ), for: .normal)
            self.player?.play()
        }
        
        self.isPlaying = !self.isPlaying
    }
    
    fileprivate func setupVideoPlayer() {
//        let urlString = "http://www.bluepego.com/depot/15.16.17.swords.cmp.clip.sd.mov"
        let urlString = "http://www.bluepego.com/depot/DSC_3898.MOV"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.frame
            self.layer.addSublayer(playerLayer)
            
            player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            player?.play()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            self.isPlaying = true
            self.pauseButton.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        setupVideoPlayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        controlsContainerView.addSubview(self.pauseButton)
        pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            view.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            keyWindow.addSubview(view)

            let height = keyWindow.frame.width * 9 / 16
            let frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let player = VideoPlayerView(frame: frame)
            view.addSubview(player)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { someBoole in
                // something
            })
        }
    }
}
