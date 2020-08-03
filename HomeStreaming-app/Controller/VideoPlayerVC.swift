//
//  VideoPlayerController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/28/20.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerVC: AVPlayerViewController, AVPlayerViewControllerDelegate {

    override class func awakeFromNib() {
        print("in VideoPlayer")
    }
    
    
    func initPlayer(url: String){
        let url = URL(string:url)
        let player = AVPlayer(url: url!)
        self.player = player
        player.play()
        
    }
}
