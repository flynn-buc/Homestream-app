//
//  Subfolders.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/17/20.
//

import Foundation
struct ServerSubfolder: Codable{
    let name: String
    let path: String
    let hash: Int
    let isFavorite: Bool
    let files: [ServerFile]
    let subfolders: [ServerSubfolder]
}
