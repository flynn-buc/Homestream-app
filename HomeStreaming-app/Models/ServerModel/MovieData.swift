//
//  MovieData.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import Foundation
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
    let cast: [CastData]
}
