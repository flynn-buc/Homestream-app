//
//  Item.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/17/20.
//

import Foundation
/*
 Filesystem item used to define an object to be displayed
 */
internal class FilesystemItem: Equatable {
    let name: String
    let type: FileType
    public private(set) var isFavorite = false
    let parent: FilesystemItem?
    let hash: Int // represents unique number to identify object. Will be used in URL
    
    init(name: String, type: FileType, hash: Int, isFavorite: Bool, parent: FilesystemItem? = nil){
        self.name = name
        self.type = type
        self.parent = parent
        self.hash = hash
        self.isFavorite = isFavorite;
    }
    // Compare whether two items are equal
    static func == (lhs: FilesystemItem, rhs: FilesystemItem) -> Bool{
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.hash == rhs.hash
    }
    
    func setFavorite(favorite: Bool){
        self.isFavorite = favorite
    }
}


