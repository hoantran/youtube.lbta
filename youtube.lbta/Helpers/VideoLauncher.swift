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
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoProgressLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named: "thumb") , for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                // rum
            })
        }
        
    }
    
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
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            player?.play()
            
            let interval = CMTime(seconds: 1, preferredTimescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds / 60))
                
                self.videoProgressLabel.text = "\(minutesText):\(secondsText)"
                
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds/durationSeconds)
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds/60))
                
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        } else if keyPath == "status" {
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
        
        setupGradientLayer()
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        controlsContainerView.addSubview(self.pauseButton)
        pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoProgressLabel)
        videoProgressLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        videoProgressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoProgressLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoProgressLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: videoProgressLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradient)
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
