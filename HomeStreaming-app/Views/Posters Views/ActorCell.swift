//
//  TVActorCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/3/20.
//


import UIKit
import CachyKit
class ActorCell: UICollectionViewCell {
    
    let actorImage = UIImageView()
    let nameLabel = CustomUILabel()
    let characterLabel = CustomUILabel()
    
    /// Create a cell with a rounded Image for the actor's picture, with two centered labels below for name & character name.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        actorImage.contentMode = .scaleAspectFill
        actorImage.clipsToBounds = true
        actorImage.layer.cornerRadius = 10
        actorImage.layer.cornerCurve = .continuous
        
        self.contentView.addSubview(actorImage)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(characterLabel)
    
        actorImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont(name: "Avenir Book", size: 14)
        nameLabel.textColor = UIColor(named: "AccentColor")
        nameLabel.textAlignment = .center
        
        characterLabel.font = UIFont(name: "Avenir Book", size: 12)
        characterLabel.textAlignment = .center
        characterLabel.lineBreakMode = .byClipping
        characterLabel.numberOfLines = 1
        characterLabel.adjustsFontSizeToFitWidth = true
        
        let actorViewconstraints = [actorImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                                    actorImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                    actorImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                                    actorImage.heightAnchor.constraint(equalToConstant: 145),
                                    actorImage.widthAnchor.constraint(equalToConstant: 120)]
        
        let nameLabelConstraints = [nameLabel.topAnchor.constraint(equalTo: actorImage.bottomAnchor, constant: 3),
                                    nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 3),
                                    nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 3)]
        
        let characterLabelConstraints = [characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
                                         characterLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 3),
                                         characterLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 3),
                                         characterLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 1)
        ]
        
        NSLayoutConstraint.activate(actorViewconstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(characterLabelConstraints)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Initiate an cell to display an Actor's image, name and character in the current show
    /// - Parameter image: String URL for the image
    /// - Parameter name: name of actor
    /// - Parameter characterName: name of the character the actor plays
    func initView(image: String, name: String, characterName: String){
        nameLabel.text = name
        characterLabel.text = characterName
        if (image == "blank poster"){
            actorImage.image = UIImage(named: image)
        }else{
            actorImage.load(url: URL(string: image)!, placeholder: nil)
            
        }
    }
}
