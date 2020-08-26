//
//  VideoPlayerController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/28/20.
//

import UIKit
import MediaPlayer
import AVKit

class VideoPlayerVC: UIViewController {
    
    private let ANIMATION_DURATION = 0.50
    
    @IBOutlet weak var volumeSliderView: UIView!
    @IBOutlet weak var bottomView: UIView!
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
    var delegate: VideoPlayerDelegate?
    private weak var fadeOutTimer: Timer?
    private weak var timestampTimer: Timer?
    private var mpVolumeView: SystemVolumeView?
    private var hasStarted = false;
    private var controlsAreVisible: Bool = false
    private var statusBarHidden: Bool = true
    private var sliderIsBeingDragged = false
    private var volumeSliderVisible = true
    private var volumeSliderWidth: CGFloat = 0.0
    private var fileHash: Int = 0
    private var beginningTimestamp: Float = 0
    
    private let player: VLCMediaPlayer = {
        let player = VLCMediaPlayer()
        return player
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        extendedLayoutIncludesOpaqueBars = true
        mpVolumeView = SystemVolumeView(frame: volumeSliderView.bounds)
        if let mpVolumeView = mpVolumeView{
            mpVolumeView.frame.size = volumeSliderView.frame.size
            mpVolumeView.showsRouteButton = false
            mpVolumeView.setVolumeThumbImage(UIImage(named: "thumb.png"), for: .normal)
            mpVolumeView.setVolumeThumbImage(UIImage(named: "thumb.png"), for: .highlighted)
            mpVolumeView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
            volumeSliderView.addSubview(mpVolumeView)
            volumeSliderWidth = volumeSliderView.frame.width
        }
        
        let tap = UITapGestureRecognizer(target:self, action: #selector(self.toggleControlView))
        playerView.addGestureRecognizer(tap)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func initPlayer(url: String, fileHash: Int, beginningTimestamp: Int){
        guard let ip = UserPrefs.data.string(forTextKey: .localIP),
              let port = UserPrefs.data.string(forTextKey: .port),
              let url = URL(string: "http://\(ip):\(port)\(url)") else{return}
        
        self.fileHash = fileHash
        self.beginningTimestamp = Float(beginningTimestamp) / 10000.0
        print("Beginning time: \(self.beginningTimestamp)")
        let media = VLCMedia(url: url)
        media.delegate = self
        player.media = media
        player.delegate = self
        player.drawable = playerView
        print("Playing (video Player): \(String(describing: url.absoluteString))")
        playButton.setImage(UIImage(systemName: "pause"), for:.normal)
        

        player.play()
        pausePlayback()
        sleep(UInt32(1))
        player.position = self.beginningTimestamp
        resumePlayback()
        timestampTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(saveTimestamp), userInfo: nil, repeats: true)
        timestampTimer?.tolerance = 3.0
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
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    
    func adjustPlaybackPosition(){
        player.pause()
        let totalTime = Float(player.media.length.intValue)/1000
        let elapsedTime = Float(player.time.intValue)/1000
        let timeToBeAt = (timeSlider.value * Float(totalTime))
        let timeToAdd = timeToBeAt - Float(elapsedTime)
        player.jumpForward(Int32(timeToAdd))
        player.play()
        player.position = timeSlider.value
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        cancelAnimations()
        if segue.identifier == "displayVideoInfoSegue"{
            if let destinationVC = segue.destination as? VideoInfoPopupVC{
                destinationVC.initView(player: player)
            }
        }
    }
    
    func showAirplay() {
        cancelAnimations()
        let rect = CGRect(x: -100, y: 0, width: 0, height: 0)
        let airplayVolume = MPVolumeView(frame: rect)
        airplayVolume.showsVolumeSlider = false
        self.view.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airplayVolume.removeFromSuperview()
        scheduleFadeout()
    }
    
    @objc func saveTimestamp(){
        if let delegate = delegate{
            delegate.saveTimestamp(timestamp: Int(player.position * 10000), hash: fileHash)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
       saveTimestamp()
        timestampTimer?.invalidate()
        super.dismiss(animated: flag) {
            self.scheduleFadeout()
        }
    }
}

// Animations
extension VideoPlayerVC {
    private func fadeInThenFadeOut(view: UIView, duration: TimeInterval, delay: TimeInterval = 0, completion: @escaping ()->Void){
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
    
    private func fadeIn(view: UIView, duration: TimeInterval = 1, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        statusBarHidden = false
        UIView.animate(withDuration: duration, delay: delay, options: [UIView.AnimationOptions.curveEaseIn, .allowUserInteraction], animations: {
            view.alpha = 0.90
        }, completion: completion)  }
    
    private func fadeOut(view: UIView, duration: TimeInterval = 1, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        statusBarHidden = true
        UIView.animate(withDuration: duration, delay: delay, options: [UIView.AnimationOptions.curveEaseIn,.allowUserInteraction], animations: {
            view.alpha = 0.0
        }, completion: completion)
    }
    
    private func cancelAnimations() {
        fadeOutTimer?.invalidate()
        mediaControlsView.layer.removeAllAnimations()
    }
    
    private func scheduleFadeout(){
        fadeOutTimer?.invalidate()
        fadeOutTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(fadeOutControls), userInfo: nil, repeats: false)
        fadeOutTimer?.tolerance = 0.2
    }
    
    @objc func fadeOutControls(){
        if fadeOutTimer != nil{
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
        else{
            if player.position > 0.995 && !player.isPlaying{
                dismiss(animated: true)
            }
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        if !sliderIsBeingDragged{
            timeSlider.value = player.position
        }
        
        hasStarted = true
        if let elapsedTime = player.time{
            let totalTime = player.media.length
            timeElapsedLbl.text = elapsedTime.stringValue
            totalTimeLbl.text = totalTime.stringValue
            if !sliderIsBeingDragged{
                timeSlider.value = player.position
            }
        }
    }
}


//IBActions
extension VideoPlayerVC{
    //Slider actions
    @IBAction func timeSliderTouchUpInside(_ sender: Any) {
        sliderIsBeingDragged = false
    }
    
    @IBAction func timeSliderTouchCancel(_ sender: Any) {
        sliderIsBeingDragged = false
    }
    @IBAction func timeSliderTouchDown(_ sender: Any) {
        sliderIsBeingDragged = true
    }
    
    @IBAction func timeSliderTouchDragInside(_ sender: Any) {
        sliderIsBeingDragged = true
        pausePlayback()
        adjustPlaybackPosition()
    }
    
    @IBAction func timeSliderMoved(_ sender: Any) {
        sliderIsBeingDragged = true
        resumePlayback()
        adjustPlaybackPosition()
    }
    
    // Other actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        pausePlayback()
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
    
    @IBAction func fullScreenArrowsPressed(_ sender: Any) {
        
    }
    
    @IBAction func airplayButtonPressed(_ sender: Any) {
        showAirplay()
    }
    
    @IBAction func videoSettingsButtonPressed(_ sender: Any) {
        if let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "videoSettingsVC") as? VideoSettingsPopupVC{
            if UIDevice.current.userInterfaceIdiom == .phone{
                let activityController = CustomActivityViewController(controller: destinationVC)
                
                destinationVC.initView(player: player)
                self.present(activityController, animated: true, completion: nil)
            }else{ // ipad
                cancelAnimations()
                destinationVC.initView(player: player)
                destinationVC.modalPresentationStyle = .popover
                destinationVC.modalTransitionStyle = .crossDissolve
                destinationVC.popoverPresentationController?.sourceView = bottomView
                self.present(destinationVC, animated: true, completion: nil)
            }
        }
        
    }
}
