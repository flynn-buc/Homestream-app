//
//  SeasonsTableSectionHeaderView.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/4/20.
//

import UIKit

///Represents a header for a UITableView with two labels (Season num and episode count) and a button to display more details about the season
class SeasonsTableSectionHeaderView: UITableViewHeaderFooterView {
    private let episodeLabel = UILabel()
    private let seasonLabel =  UILabel()
    let moreDetailsButton = UIButton()
    
    private let icon = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))
    private let font = UIFont(name: "Avenir Book", size: 13)
    
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Align the two labels on the left side of the header, and align the button on the right side. Size to take all the space of the header
    func configureViews(){
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
        
        seasonLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeLabel.translatesAutoresizingMaskIntoConstraints = false
        moreDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(seasonLabel)
        contentView.addSubview(episodeLabel)
        contentView.addSubview(moreDetailsButton)

        seasonLabel.font = font
        episodeLabel.font = font
        moreDetailsButton.titleLabel?.font = font
        
        let margins = contentView.layoutMarginsGuide
        
        let constraints = [seasonLabel.topAnchor.constraint(equalTo: margins.topAnchor),
                           seasonLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3),
                           seasonLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                           episodeLabel.topAnchor.constraint(equalTo: margins.topAnchor),
                           episodeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                           episodeLabel.leadingAnchor.constraint(equalTo: seasonLabel.trailingAnchor),
                           moreDetailsButton.topAnchor.constraint(equalTo: margins.topAnchor),
                           moreDetailsButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                           moreDetailsButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 3)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Setup the header with the specified season num and number of episodes
    /// - Parameter seasonNum: int value of the season
    /// - Parameter numberOfEpisodes: int value of the count of episode in this season
    func setup(seasonNum: Int, numberOfEpisodes:Int){
        seasonLabel.text = "Season \(seasonNum) - "
        episodeLabel.text = "\(numberOfEpisodes) episodes"
        moreDetailsButton.setTitle("See All ", for: .normal)
        moreDetailsButton.setImage(icon, for: .normal)
        moreDetailsButton.setTitleColor(UIColor.secondaryLabel, for: .normal)
        seasonLabel.textColor = UIColor.secondaryLabel
        episodeLabel.textColor = UIColor.secondaryLabel
        moreDetailsButton.imageToRight()
        
        self.layoutIfNeeded()
    }
}
