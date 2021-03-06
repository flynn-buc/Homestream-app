//
//  MessageData.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import Foundation

struct MessageData: Codable{
    let message: String
    let path: String
    let currentFolder: String
    let folders: ServerSubfolder
}
