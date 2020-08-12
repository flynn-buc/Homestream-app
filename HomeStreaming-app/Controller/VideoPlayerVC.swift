//
//  VideoPlayerController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/28/20.
//

import UIKit
import MediaPlayer


class VideoPlayerVC: UIViewController {
    
    private let ANIMATION_DURATION = 0.50
    
    private var sliderIsBeingDragged = false
    private var currentSliderTime: Float = 0.0
    
    private var timer = Timer()
    @IBOutlet weak var timeSlider: SmallSlider!
    @IBOutlet weak var timeElapsedLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var mediaControlsView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerView: UIView!{
        didSet{
            self.playerView.backgroundColor = UIColor.black
        }
    }
    
    private var hasStarted = false;
    
    
    private var controlsAreVisible: Bool = false
    private var statusBarHidden: Bool = true
    
    
    let player: VLCMediaPlayer = {
        let player = VLCMediaPlayer()
        return player
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func initPlayer(url: String){
        guard let ip = UserPrefs.data.string(forTextKey: .localIP), let port = UserPrefs.data.string(forTextKey: .port) else{return}
        let url = URL(string: "http://\(ip):\(port)\(url)")
        
        
        mediaControlsView.isHidden = true
        
        timeSlider.maximumValue = 100
        timeSlider.minimumValue = 0
        if let url = url{
            let media = VLCMedia(url: url)
            media.delegate = self
            player.media = media
            player.delegate = self
            player.drawable = playerView
            print("Playing: \(String(describing: url.absoluteString))")
            playButton.setImage(UIImage(systemName: "pause"), for:.normal)
            let tap = UITapGestureRecognizer(target:self, action: #selector(self.toggleControlView))
            playerView.addGestureRecognizer(tap)
            player.play()
        }
    }
    
    @objc func toggleControlView(){
        if (controlsAreVisible){
            mediaControlsView.layer.removeAllAnimations()
            mediaControlsView.becomeFirstResponder()
            for view in mediaControlsView.subviews{
                mediaControlsView.bringSubviewToFront(view)
            }
            fadeOut(view: mediaControlsView, duration: ANIMATION_DURATION) { (finished) in
                if (finished){
                    self.controlsAreVisible = false
                }
            }
        }else{
            fadeInThenFadeOut(view: mediaControlsView, duration: ANIMATION_DURATION) {
                self.controlsAreVisible = false
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    
    func setStatusBar(hidden: Bool, delay: TimeInterval = 0.0) {
        statusBarHidden = hidden
        UIView.animate(withDuration: ANIMATION_DURATION, delay: delay, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (success: Bool) in
        }
    }
    
    @IBAction func volumeSliderChanged(_ sender: Any) {
        if let slider = sender as? SmallSlider{
            MPVolumeView.setVolume(slider.value)
            scheduleFadeout()
        }
    }
    
    func adjustPlaybackPosition(){
        player.pause()
        let totalTime = Float(player.media.length.intValue)/1000
        let elapsedTime = Float(player.time.intValue)/1000
        let timeToBeAt = (timeSlider.value/100 * Float(totalTime))
        let timeToAdd = timeToBeAt - Float(elapsedTime)
        player.jumpForward(Int32(timeToAdd))
        
        print("\(timeSlider.value)")
        print("time to be at: \(timeToBeAt), time to add: \(timeToAdd)")
        player.play()
        scheduleFadeout()
    }
    
    private func pausePlayback(){
        player.pause()
        cancelAnimations()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    private func resumePlayback(){
        player.play()
        scheduleFadeout()
        playButton.setImage(UIImage(systemName: "pause"), for: .normal)
    }
    
    
}

// Animations
extension VideoPlayerVC {
    
    func fadeInThenFadeOut(view: UIView, duration: TimeInterval, delay: TimeInterval = 0, completion: @escaping ()->Void){
        controlsAreVisible = true
        if player.isPlaying{
            scheduleFadeout()
        }
        if controlsAreVisible{
            playerView.bringSubviewToFront(mediaControlsView)
            for view in mediaControlsView.subviews{
                playerView.bringSubviewToFront(view)
            }
        }
        fadeIn(view: view, duration: duration, delay: delay)
    }
    
    
    func fadeIn(view: UIView, duration: TimeInterval = 1, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: [UIView.AnimationOptions.curveEaseIn, .allowUserInteraction], animations: {
            view.alpha = 0.90
        }, completion: completion)  }
    
    func fadeOut(view: UIView, duration: TimeInterval = 1, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: [UIView.AnimationOptions.curveEaseIn,.allowUserInteraction], animations: {
            view.alpha = 0.0
        }, completion: completion)
    }
    
    fileprivate func cancelAnimations() {
        timer.invalidate()
        timer = Timer()
        mediaControlsView.layer.removeAllAnimations()
    }
    
    func scheduleFadeout(){
        timer.invalidate()
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(fadeOutControls), userInfo: nil, repeats: false)
        timer.tolerance = 0.2
    }
    
    @objc func fadeOutControls(){
        if timer.isValid{
            fadeOut(view: mediaControlsView, duration: ANIMATION_DURATION) { (finished) in
                self.controlsAreVisible = false
            }
        }
    }
}

extension VideoPlayerVC: VLCMediaDelegate, VLCMediaPlayerDelegate{
    
    func mediaDidFinishParsing(_ aMedia: VLCMedia) {
        print("Finished Parsing")
    }
    
    func mediaMetaDataDidChange(_ aMedia: VLCMedia) {
        print("MetaData Changed")
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if player.willPlay{
            if (hasStarted){
                mediaControlsView.isHidden = false
                mediaControlsView.becomeFirstResponder()
                totalTimeLbl.text = player.media.length.stringValue
                fadeInThenFadeOut(view: mediaControlsView, duration: ANIMATION_DURATION, delay: 1) {
                    self.controlsAreVisible = false
                }
            }
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        hasStarted = true
        if let elapsedTime = player.time{
            let totalTime = player.media.length
            timeElapsedLbl.text = elapsedTime.stringValue
            totalTimeLbl.text = totalTime.stringValue
            if !sliderIsBeingDragged{
                timeSlider.setValue(Float(elapsedTime.intValue)/Float(totalTime.intValue) * 100.0, animated: true)
            }
        }
    }
}


//IBActions
extension VideoPlayerVC{
    //Slider actions
    @IBAction func touchUpInside(_ sender: Any) {
        sliderIsBeingDragged = false
    }
    
    @IBAction func touchCancel(_ sender: Any) {
        sliderIsBeingDragged = false
    }
    @IBAction func touchDown(_ sender: Any) {
        sliderIsBeingDragged = true
    }
    
    @IBAction func touchDragExit(_ sender: Any) {
        timeSlider.cancelTracking(with: .none)
        sliderIsBeingDragged = false
    }
    
    @IBAction func touchDragInside(_ sender: Any) {
        pausePlayback()
        adjustPlaybackPosition()
    }
    
    @IBAction func timeSliderMoved(_ sender: Any) {
        resumePlayback()
        adjustPlaybackPosition()
    }
    
    // Other actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rewind15BtnPressed(_ sender: Any) {
        player.jumpBackward(15)
        scheduleFadeout()
    }
    
    @IBAction func forward30BtnPressed(_ sender: Any) {
        player.jumpForward(30)
        scheduleFadeout()
    }
    
    @IBAction func playPauseBtnPressed(_ sender: Any) {
        if player.isPlaying{
            pausePlayback()
        }else{
            resumePlayback()
        }
    }
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
