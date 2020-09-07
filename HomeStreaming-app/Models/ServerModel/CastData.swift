//
//  CastData.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import Foundation
//Defines cast data received from server, used to display
struct CastData: Codable{
    let id: Int
    let name: String
    let image: String
    let character: String
    let order: Int
}
