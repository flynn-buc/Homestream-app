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
        guard let ip = UserPrefs.data.string(forTextKey: .localIP), let port = UserPrefs.data.string(forTextKey: .port) else{return}
        let url = URL(string: "http://\(ip):\(port)\(url)")
        print("Playing: \(String(describing: url?.absoluteString))")
        let player = AVPlayer(url: url!)
        self.player = player
        player.play()
        
    }
}
