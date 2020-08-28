//
//  MovieVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit
import GradientView
import TransitionButton


@IBDesignable

class MovieVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, VideoPlayerDelegate {
    
    
    private var cast: [CastData]?
    private var movieFile: MovieFile!
    private var movieDataSource: MoviePosterDataSource!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDatelabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var boxOfficeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var summaryLabel: UITextView!
    @IBOutlet weak var favoritesButton: FavoritesButton!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var watchedTextLabel: UILabel!
    @IBOutlet weak var playButton: TransitionButton!
    
    @IBOutlet weak var filenameLabel: UILabel!
    @IBOutlet weak var backgroundView: GradientView!
    
    private var linkedFavoriteButton: FavoritesButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actorCollectionView.dataSource = self
        actorCollectionView.delegate = self
        
        backgroundView.colors = [#colorLiteral(red: 0.04346175426, green: 0.003437370047, blue: 0.1737785533, alpha: 1), .black, #colorLiteral(red: 0.04346175426, green: 0.003437370047, blue: 0.1737785533, alpha: 1)]
        backgroundView.direction = .vertical
        
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        if let data = movieFile.data, let movie = movieFile{
            titleLabel.text = data.title
            releaseDatelabel.text = data.date
            budgetLabel.text = "\(numberFormatter.string(from: NSNumber(value: data.budget))!)"
            boxOfficeLabel.text = "\(numberFormatter.string(from: NSNumber(value: data.boxoffice))!)"
            runtimeLabel.text = "\(data.runtime) minutes"
            languageLabel.text = data.language
            summaryLabel.text = data.description
            watchedLabel.text = "\(movieFile.playbackPosition / 100)%"
            cast = data.cast
            actorCollectionView.reloadData()
            favoritesButton.setItem(item: movieFile)
            favoritesButton.set(isFavorite: movieFile.isFavorite)
            filenameLabel.text = "Matched from file: \(movie.name)"
            if (data.image == "blank poster"){
                poster.image = UIImage(named: data.image)
            }else{
                poster.downloaded(from: data.image)
            }
        }
    }
    
    func linkFavoritesButtons(button: FavoritesButton){
        self.linkedFavoriteButton = favoritesButton
    }
    
    
    func initView(movie: MovieFile, movieDataSource: MoviePosterDataSource){
        self.movieFile = movie
        self.movieDataSource = movieDataSource
    }
    
    
    func updateFavoritesButton(){
        if movieFile.isFavorite{
            favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed{
            linkedFavoriteButton?.setNeedsDisplay()
        }
    }
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
        self.playButton.startAnimation()
        playButton.backgroundColor = UIColor.black
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            ClientService.instance.play(file: self.movieFile) { (serverFile) in
                print("Will Play: \(serverFile.name)")
                let videoSB = UIStoryboard(name: "VideoPlayer", bundle: nil)
                guard let videoPlayerVC = videoSB.instantiateViewController(identifier: "videoPlayerVC") as? VideoPlayerVC else {
                    print("failed")
                    return
                }
                
                self.movieFile.setPlaybackPosition(playbackPosition: serverFile.playbackPosition)
                self.movieFile.setFavorite(favorite: serverFile.isFavorite)
                videoPlayerVC.modalPresentationStyle = .fullScreen
                videoPlayerVC.modalTransitionStyle = .crossDissolve
                videoPlayerVC.view.backgroundColor = UIColor.black
                videoPlayerVC.delegate = self
                let pathURL = "/\(String.pathAsURL(self.movieFile.hash))" // convert file hash to URL
                videoPlayerVC.initPlayer(url: "\(pathURL)/Play/", fileHash: self.movieFile.hash, beginningTimestamp: serverFile.playbackPosition)
                print("Playing...: http://nissa.local:3004/\(self.movieFile.hash)/Play/")
                
                UIView.animate(withDuration: 0.2, animations: {  self.watchedLabel.alpha = 0; self.watchedTextLabel.alpha = 0; self.favoritesButton.alpha = 0})
                
                self.playButton.stopAnimation(animationStyle: .expand) {
                    self.present(videoPlayerVC, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.playButton.backgroundColor = UIColor.clear
                        self.watchedLabel.alpha = 1
                        self.favoritesButton.alpha = 1
                        self.watchedTextLabel.alpha = 1
                    }
                }
                
            } onError: { (message) in
                print("error: \(message)")
                self.playButton.stopAnimation(animationStyle: .shake)
                self.playButton.backgroundColor = UIColor.clear
            }
        }
    }
    
    func saveTimestamp(timestamp: Int, hash: Int) {
        movieFile.setPlaybackPosition(playbackPosition: timestamp)
        movieDataSource.patch(data: movieFile)
        watchedLabel.text = "\(movieFile.playbackPosition / 100)%"
    }
    
    @IBAction func favoritesButtonPressed(_ sender: FavoritesButton) {
        favoritesButton.set(isFavorite: !movieFile.isFavorite)
        linkedFavoriteButton?.set(isFavorite: favoritesButton.isFavorite())
        movieDataSource.patch(data: movieFile)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorCell", for: indexPath) as? ActorCell, let cast = cast?[indexPath.row] {
            cell.initView(image: cast.image, name: cast.name, characterName: cast.character)
            return cell
        }
        
        return ActorCell()
    }
}
