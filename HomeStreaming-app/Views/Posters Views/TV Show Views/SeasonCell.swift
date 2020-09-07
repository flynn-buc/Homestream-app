//
//  SeasonCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/4/20.
//

import UIKit

///Represents a cell which contains a collection view of TVEpisodes
class SeasonCell: UITableViewCell {
    @IBOutlet weak var seasonCollectionView: UICollectionView!
    public private(set) var seasonNum: Int!
    private var collectionViewDataSource: SeasonCollectionViewDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    ///Init cell with a season number and a data source for the underlying collection view
    /// - Parameter seasonNum: integer representation of the season number
    /// - Parameter collectionViewDataSource: data source for the season collection view
    func initView(seasonNum: Int, collectionViewDataSource: SeasonCollectionViewDataSource){
        self.seasonNum = seasonNum
        seasonCollectionView.tag = seasonNum
        self.collectionViewDataSource = collectionViewDataSource
        seasonCollectionView.dataSource = self.collectionViewDataSource
        
    }
    
}
