//
//  MessageData.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import Foundation
import SocketIO

struct MessageData: Codable{
    let message: String
    let path: String
    let currentFolder: String
    let folders: Subfolders
}
