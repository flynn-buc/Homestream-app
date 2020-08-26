//
//  ActorCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit

class ActorCell: UICollectionViewCell {


    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    
    
    func initView(image: String, name: String, characterName: String){
        nameLabel.text = name
        characterLabel.text = characterName
        actorImage.downloaded(from: image)
        
    }
}
