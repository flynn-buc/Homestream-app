//
//  EpisodeCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/4/20.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeLabel: CustomUILabel!
    
    ///Round the corners of the view
    override func awakeFromNib() {
        episodeImage.layer.cornerRadius = 10
    }
    
    /// Initializes an episode cell, with a still image and an episode title (often seasn # and episode #
    /// - Parameter image: String URL Address of image
    /// - Parameter title: episode title
    func initView(image: String, title: String){
        episodeLabel.text = title
        if (image == "blank poster" || image == ""){
            episodeImage.image = UIImage(named: "blank poster")
        }else{
            episodeImage.load(url: URL(string: image)!, placeholder: nil)
        }
    }
}
