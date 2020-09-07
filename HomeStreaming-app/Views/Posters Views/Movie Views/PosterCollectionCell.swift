//
//  PosterCollectionCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit

class PosterCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoritesButton: FavoritesButton!
    
    private let refreshControl = UIRefreshControl()
    
    /// Setup a poster cell for movies using the title, small poster, and favorites status of a movie
    /// - Parameter MovieFile: The movie file to dsiplay as a poster
    func setup(movieFile: MovieFile){
        if let data = movieFile.data{
            titleLabel.text = data.title
            if (data.image == "blank poster"){
                posterImage.image = UIImage(named: data.image)
            }else{
                posterImage.load(url: URL(string: data.smallPoster)!, placeholder: nil)
            }
        }
        
        favoritesButton.setItem(item: movieFile)
        favoritesButton.set(isFavorite: movieFile.isFavorite)
    }
}


