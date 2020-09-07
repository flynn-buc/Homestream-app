//
//  TVShowData.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/2/20.
//

import Foundation
//TV Show object received from server
struct TVShowData: Codable{
    let data: [TVShow]
}

//Represent an individual TV Show, with seasons
struct TVShow: Codable{
    let title: String
    let image: String
    let id: Int
    let overview: String
    let language: String
    let status: String
    let firstAired: String
    let nextToAir: String
    let lastAired: String
    let runtime: Int
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let backdrop: String
    let smallBackdrop: String
    let inProduction: Bool
    let isFavorite: Bool
    let hasLinkedEpisode:Bool
    let seasons: [TVSeason]
}

//Represents a TVSeasons, with an array of episodes and cast
struct TVSeason: Codable{
    let image: String
    let id: Int
    let title: String
    let overview: String
    let date:String
    let seasonNum: Int
    let numOfEpisodes: Int
    let isFavorite: Bool
    let hasLinkedEpisode: Bool
    let cast: [CastData]
    let episodes: [TVEpisodes]
}

//Represents an individual TV Episode
struct TVEpisodes: Codable{
    let image: String
    let id: Int
    let title: String
    let overview: String
    let date: String
    let episodeNum: Int
    let seasonNum: Int
    let showID: Int
    let filehash: Int
    let cast: [CastData]
}
