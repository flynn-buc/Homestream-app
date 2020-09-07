//
//  PosterPageVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/25/20.
//

import UIKit
import Parchment

class MoviePosterPageVC: PosterNavVC {
    var movieVC: UIViewController!
    var favoritesVC: UIViewController!
    
    override func viewDidLoad() {
        let movieStoryboard = UIStoryboard(name: "MoviePosters", bundle: nil)
        
        if let vc = movieStoryboard.instantiateViewController(identifier: "posterCollectionVC") as? MoviePosterCollectionVC{
            movieVC = vc
        }

        if let vc = movieStoryboard.instantiateViewController(identifier: "posterCollectionVC") as? MoviePosterCollectionVC{
            vc.movieDataSource = MoviePosterDataSource(dataManager: FavoritesDataManager())
            favoritesVC = vc
        }
        
        movieVC.title = "Movie"
        favoritesVC.title = "Favorites"

        controllers = [movieVC, favoritesVC]
        
        super.viewDidLoad()
    }
}
