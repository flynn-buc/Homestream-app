//
//  VideoSettingsPopupVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/13/20.
//

import UIKit

class VideoSettingsPopupVC: UITableViewController {
    
    @IBOutlet weak var subtitleDelayLabel: UILabel!
    @IBOutlet weak var audioDelayLabel: UILabel!
    
    private var subtitleDelay: Int = 0 // in microseconds
    private var audioDelay: Int = 0 // in microseconds: 100,000 microseconds = 0.1s
    
    private var player: VLCMediaPlayer?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popoverPresentationController?.permittedArrowDirections = .down
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        self.view.isOpaque = false
        self.view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.95)
        self.view.layer.borderWidth = 0.5
        
        updateAudioDelayLabel()
        updateSubtitleDelayLabel()
        
        
    }
    
    
    func initView(player: VLCMediaPlayer){
        
        
        
        
        
        audioDelay = player.currentAudioPlaybackDelay
        subtitleDelay = player.currentVideoSubTitleDelay
        self.player = player
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    private func updateAudioDelayLabel(){
        let audioDelayDisplay = Float(audioDelay)/1000000.0
        audioDelayLabel.text = "\(audioDelayDisplay)s"
        player?.currentAudioPlaybackDelay = audioDelay
    
    }
    
    private func updateSubtitleDelayLabel(){
        let subtitleDelayDisplay = Float(subtitleDelay)/1000000.0
        subtitleDelayLabel.text = "\(subtitleDelayDisplay)s"
        player?.currentVideoSubTitleDelay = subtitleDelay
    }
    
    @IBAction func audioDelayIncreased(_ sender: Any) {
        audioDelay += 100000
        updateAudioDelayLabel()
    }
    
    @IBAction func audioDelayDecreased(_ sender: Any) {
            audioDelay -= 100000
            updateAudioDelayLabel()
    }
    
    @IBAction func subDelayIncreased(_ sender: Any) {
        subtitleDelay += 100000
        updateSubtitleDelayLabel()
    }
    
    @IBAction func subDelayDecreased(_ sender: Any) {
        subtitleDelay -= 100000
        updateSubtitleDelayLabel()
    }
    
    @IBAction func resetAudioDelay(_ sender: Any) {
        audioDelay = 0
        updateAudioDelayLabel()
    }
    
    @IBAction func resetSubtitleDelay(_ sender: Any) {
        subtitleDelay = 0
        updateSubtitleDelayLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.preferredContentSize = self.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
    }
}
