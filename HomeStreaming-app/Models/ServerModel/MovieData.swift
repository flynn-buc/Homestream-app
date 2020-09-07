//
//  MovieData.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import Foundation
//Defines movie data received from server, to be used to display
struct MovieData: Codable{
    let title: String
    let id: Int
    let image: String
    let language: String
    let date: String
    let description: String
    let budget: Int
    let boxoffice: Int
    let runtime: Int
    let director: String
    let producers: String
    let smallPoster: String
    let backdrop: String
    let cast: [CastData]
    let rating: Double
    let genres: [String]
}
