//
//  MovieVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit
import GradientView
import TransitionButton
import CachyKit
import BlurredModalViewController

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
    @IBOutlet weak var summaryLabel: UITextView!
    @IBOutlet weak var favoritesButton: FavoritesButton!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var watchedTextLabel: UILabel!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet  var starRating: StarRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producersLabel: UILabel!
    
    @IBOutlet weak var filenameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var seenLabel: UILabel!
    @IBOutlet weak var seenButton: UIButton!
    
    private var canBeDismissed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actorCollectionView.dataSource = self
        actorCollectionView.delegate = self
        actorCollectionView.register(ActorCell.self, forCellWithReuseIdentifier: "actorCell")
        
        view.backgroundColor = .systemBackground
        backgroundView.alpha = 0
        scrollView.delegate = self
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        if let data = movieFile.data, let movie = movieFile{
            titleLabel.text = "\(data.title) (\(data.date.suffix(4)))"
            releaseDatelabel.text = data.date
            budgetLabel.text = "\(numberFormatter.string(from: NSNumber(value: data.budget))!)"
            boxOfficeLabel.text = "\(numberFormatter.string(from: NSNumber(value: data.boxoffice))!)"
            runtimeLabel.text = "\(data.runtime) min"
            summaryLabel.text = data.description
            directorLabel.text = data.director
            producersLabel.text = data.producers
            updateWatchedLabel()
            setGenre(genres: data.genres)
            setStarRating(rating: data.rating)
            cast = data.cast
            actorCollectionView.reloadData()
            favoritesButton.setItem(item: movieFile)
            favoritesButton.set(isFavorite: movieFile.isFavorite)
            updateFavoritesButton()
            filenameLabel.text = "Matched from file: \(movie.name)"
            if (data.image == "blank poster"){
                poster.image = UIImage(named: data.image)
            }else{
                poster.cachyImageLoad(URL(string: data.image)!, isShowLoading: true){_,_ in}
            }
            if data.backdrop != ""{
                backdropImageView.load(url: URL(string: data.backdrop)!, placeholder: nil)
            }
        }
        view.bringSubviewToFront(playButton)
        
        actorCollectionView.sizeToFit()
    }
    
    func initView(movie: MovieFile, movieDataSource: MoviePosterDataSource){
        self.movieFile = movie
        self.movieDataSource = movieDataSource
    }
    
    private func setStarRating(rating: Double){
        ratingLabel.text = "\(rating)/10"
        let rating: Float = Float(rating)/2.0
        starRating = StarRatingView(frame: starRating.frame, rating: rating, color: UIColor.systemYellow, starRounding: StarRounding.roundToHalfStar)
        starRating.isUserInteractionEnabled = false
    }
    
    private func setGenre(genres: [String]){
        var genreToAssign = genres
        if (genres.count == 0){
            return
        }
        print(genreToAssign.count)
        print(genreToAssign.count > 3 ? 3:genreToAssign.count)
        for i in 0 ... (genreToAssign.count > 3 ? 3: genreToAssign.count - 1){
            if genreToAssign[i] == "Science Fiction"{
                genreToAssign[i] = "Sci-Fi"
                break;
            }
            if i == 3{
                break;
            }
        }
        
        if genreToAssign.count > 3{
            genreLabel.text = "\(genreToAssign[0]) • \(genreToAssign[1]) • \(genreToAssign[2])"
        }else if genres.count == 2{
            genreLabel.text = "\(genreToAssign[0]) • \(genreToAssign[1])"
        }else{
            genreLabel.text = "\(genreToAssign[0])"
        }
    }
    
    
    
    private func updateWatchedLabel(){
        if let movie = movieFile, let data = movie.data{
            let runtime: Float = Float(data.runtime)
            let playback = Float(movie.playbackPosition)/100.0/100.0 * runtime
            seenButton.setImage(UIImage(systemName: "eye"), for: .normal)
            seenLabel.text = "Mark Seen"
            
            if (playback == 0){
                watchedLabel.text = ""
                watchedTextLabel.text = " - Not Started"
            }else if runtime - playback <= 5{
                watchedLabel.text = ""
                watchedTextLabel.text = " - Seen"
                seenButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                seenLabel.text = "Mark Not Seen"
            }else {
                watchedTextLabel.text = " - Remaining:"
                watchedLabel.text = "\(Int(runtime - playback)) min"
            }
        }
    }
    
    private func updateFavoritesButton(){
        if movieFile.isFavorite{
            favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoritesLabel.text = "Remove from Favorites"
        }else{
            favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoritesLabel.text = "Add to Favorites"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed{
            
        }
    }
    
    @IBAction func toggleSeen(_ sender: Any){
        //        if let movie = movieFile, let seen = movie.seen{
        //            if (seen){
        //
        //            }else{
        //
        //            }
        //            updateWatchedLabel()
        //        }
    }
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
        self.playButton.startAnimation()
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
                
                self.playButton.backgroundColor = UIColor.black
                self.playButton.stopAnimation(animationStyle: .expand) {
                    self.present(videoPlayerVC, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.playButton.backgroundColor = UIColor(named: "AccentColor")
                        self.playButton.resetButton()
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
        updateWatchedLabel()
        movieDataSource.patch(data: movieFile)
        
    }
    
    @IBAction func favoritesButtonPressed(_ sender: FavoritesButton) {
        favoritesButton.set(isFavorite: !movieFile.isFavorite)
        updateFavoritesButton()
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


extension MovieVC: BlurredScrollableModalView{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        canBeDismissed = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        canBeDismissed = true
    }
    
    func canDismiss() -> Bool {
        if (scrollView.contentOffset.y <= 0){
            return true
        }
        return canBeDismissed
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canBeDismissed = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
            let height = backdropImageView.bounds.height
            let heightOffset = scrollView.contentOffset.y
            
            if (heightOffset <= 0){
                backgroundView.alpha = 0
            }else if heightOffset >= height{
                backgroundView.alpha = 1
            }else{
                backgroundView.alpha = heightOffset / (height - 30)
            }
        }
    }
}
