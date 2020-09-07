//
//  SeasonCollectionViewDelegate.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/4/20.
//

import Foundation

class SeasonCollectionViewDataSource: NSObject, UICollectionViewDataSource{
    
    private let season: TVSeason
    private let section: Int
    private let viewAvailableOnly = true
    private var numAvailable = 0
    private var availableEpisodes: [TVEpisodes] = []
    
    
    init(season: TVSeason, section: Int){
        self.season = season
        self.section = section
        super.init()
        calculateNumAvailable()
    }
    
    
    private func calculateNumAvailable(){
        for episode in season.episodes{
            if (episode.filehash != -1){
                availableEpisodes.append(episode)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell", for: indexPath) as? EpisodeCell{
            let episode = season.episodes[indexPath.row]
            cell.initView(image: episode.image, title: "Season \(episode.seasonNum) Episode \(episode.episodeNum)")
            return cell
        }
        
        return EpisodeCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (viewAvailableOnly){
            return  availableEpisodes.count
        }
        return season.episodes.count
    }
    
}
