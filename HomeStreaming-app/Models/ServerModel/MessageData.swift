//
//  MessageData.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import Foundation

//Basic message response from server for all files and folders
struct MessageData: Codable{
    let message: String
    let folders: ServerSubfolder
}
