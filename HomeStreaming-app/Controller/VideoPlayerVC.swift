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

    private let dataPref = UserDefaults.init(suiteName: UserDefaultKey.userSettings)
    
    override class func awakeFromNib() {
        print("in VideoPlayer")
    }
    
    
    func initPlayer(url: String){
        guard let ip = dataPref?.string(forKey: UserDefaultKey.localIP.rawValue), let port = dataPref?.string(forKey: UserDefaultKey.port.rawValue) else{return}
        let url = URL(string: "http://\(ip):\(port)\(url)")
        let player = AVPlayer(url: url!)
        self.player = player
        player.play()
        
    }
}
