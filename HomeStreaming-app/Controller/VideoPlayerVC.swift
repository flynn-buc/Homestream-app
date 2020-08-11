//
//  VideoPlayerController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/28/20.
//

import UIKit


class VideoPlayerVC: UIViewController {

    let player: VLCMediaPlayer = {
           let player = VLCMediaPlayer()
           return player
       }()
    
    override class func awakeFromNib() {
        print("in VideoPlayer")
    }
    
    
    func initPlayer(url: String){
            guard let ip = UserPrefs.data.string(forTextKey: .localIP), let port = UserPrefs.data.string(forTextKey: .port) else{return}
            let url = URL(string: "http://\(ip):\(port)\(url)")
            
            if let url = url{
                player.media = VLCMedia(url: url)
                player.drawable = self.view
                print("Playing: \(String(describing: url.absoluteString))")
                player.play()
            }
        }
}
