//
//  VideoFile.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import Foundation
class MovieFile: File{
    public private(set) var data: MovieData?
    //A file that contains movieData
     init(name: String, type: FileType, hash: Int, isFavorite: Bool, parent: FilesystemItem? = nil, playbackPosition: Int, data: MovieData?) {
        super.init(name: name, type: type, hash: hash, isFavorite: isFavorite, parent: parent, playbackPosition: playbackPosition)
        
        self.data = data
    }
}
