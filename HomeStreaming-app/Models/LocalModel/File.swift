//
//  File.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/9/20.
//

import Foundation
// File object, can be movie or subtitle
class File: FilesystemItem{
    public private(set) var playbackPosition: Int
    
    
    init(name: String, type: FileType, hash: Int, isFavorite: Bool, parent: FilesystemItem? = nil, playbackPosition: Int) {
        self.playbackPosition = playbackPosition;
        super.init(name: name, type: type, hash: hash, isFavorite: isFavorite, parent: parent)
    }
    
    
    func setPlaybackPosition(playbackPosition: Int){
        self.playbackPosition = playbackPosition;
    }
    
    
    
}
