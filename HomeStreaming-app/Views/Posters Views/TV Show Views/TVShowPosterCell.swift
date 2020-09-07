//
//  TVShowPosterCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/2/20.
//

import UIKit

class TVShowPosterCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    ///Initialize a cell used to display TV Shows in a collection view
    /// - Parameter tvShow: the tv show to represent. Title and smallBAckdrop will be extracted to display
    func setup(tvShow: TVShow){
        titleLabel.text = tvShow.title
        if (tvShow.image == "blank poster"){
            posterImage.image = UIImage(named: tvShow.image)
        }else{
            posterImage.load(url: URL(string: tvShow.smallBackdrop)!, placeholder: nil)
            
        }
        
    }
}
