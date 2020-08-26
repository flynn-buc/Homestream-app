//
//  File.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/7/20.
//

import Foundation
struct ServerFile: Codable{
    let name: String
    let hash: Int
    let isFavorite: Bool
    let type: String
    let playbackPosition: Int
    let databaseKey: Int
    let data: MovieData?
}
