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
    
    func setup(movieFile: MovieFile){
        if let data = movieFile.data{
        titleLabel.text = data.title
            posterImage.downloaded(from: data.image)
        }
        
        favoritesButton.setItem(item: movieFile)
        favoritesButton.set(isFavorite: movieFile.isFavorite)
    }
}


