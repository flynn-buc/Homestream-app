//
//  MovieVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit
import CocoaButton
import GradientView

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
    @IBOutlet weak var playButton: CocoaButton!
    
    @IBOutlet weak var backgroundView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actorCollectionView.dataSource = self
        actorCollectionView.delegate = self
        
//
        backgroundView.colors = [#colorLiteral(red: 0.04346175426, green: 0.003437370047, blue: 0.1737785533, alpha: 1), .black, #colorLiteral(red: 0.04346175426, green: 0.003437370047, blue: 0.1737785533, alpha: 1)]
//        //backgroundView.locations = [0.8, 0.1]
        backgroundView.direction = .vertical
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        if let data = movieFile.data{
            titleLabel.text = data.title
            releaseDatelabel.text = data.date
            budgetLabel.text = "\(numberFormatter.string(from: NSNumber(value: data.budget))!)"
            boxOfficeLabel.text = "\(numberFormatter.string(from: NSNumber(value: data.boxoffice))!)"
            runtimeLabel.text = "\(data.runtime) minutes"
            languageLabel.text = data.language
            summaryLabel.text = data.description
            watchedLabel.text = "\(movieFile.playbackPosition / 100)%"
            poster.downloaded(from: data.image)
            cast = data.cast
            actorCollectionView.reloadData()
            favoritesButton.setItem(item: movieFile)
            favoritesButton.set(isFavorite: movieFile.isFavorite)
        }
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
    
    

    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClientService.instance.play(file: self.movieFile) { (serverFile) in
                print("Will Play: \(serverFile.name)")
                 let videoSB = UIStoryboard(name: "VideoPlayer", bundle: nil)
                guard let videoPlayerVC = videoSB.instantiateViewController(identifier: "videoPlayerVC") as? VideoPlayerVC else {
                    print("failed")
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.playButton.stopLoading()
                        }
                
                self.movieFile.setPlaybackPosition(playbackPosition: serverFile.playbackPosition)
                self.movieFile.setFavorite(favorite: serverFile.isFavorite)
                videoPlayerVC.modalPresentationStyle = .fullScreen
                videoPlayerVC.modalTransitionStyle = .coverVertical
                videoPlayerVC.view.backgroundColor = UIColor.black
                videoPlayerVC.delegate = self
                self.present(videoPlayerVC, animated: true, completion: nil)
                let pathURL = "/\(String.pathAsURL(self.movieFile.hash))" // convert file hash to URL
                videoPlayerVC.initPlayer(url: "\(pathURL)/Play/", fileHash: self.movieFile.hash, beginningTimestamp: serverFile.playbackPosition)
                print("Playing...: http://nissa.local:3004/\(self.movieFile.hash)/Play/")
                
            } onError: { (message) in
                print("error: \(message)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.playButton.stopLoading()
                        }
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
