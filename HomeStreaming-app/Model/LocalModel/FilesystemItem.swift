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
class FilesystemItem: Equatable {
    let name: String
    let type: FileType
    var isFavorite = false
    let parent: FilesystemItem?
    let hash: Int // represents unique number to identify object. Will be used in URL
    
    init(name: String, type: FileType, hash: Int, parent: FilesystemItem? = nil){
        self.name = name
        self.type = type
        self.parent = parent
        self.hash = hash
    }
    // Compare whether two items are equal
    static func == (lhs: FilesystemItem, rhs: FilesystemItem) -> Bool{
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.hash == rhs.hash
    }
}

// File object, can be movie or subtitle
class File: FilesystemItem{
    
}

//Folder object, olds an array of Filesystem
class Folder: FilesystemItem{
    public private(set) var items: [FilesystemItem] = []
    
    init(name: String, type: FileType, hash: Int, parent: FilesystemItem? = nil, files: [FilesystemItem]? = nil){
        if let files = files{
            self.items = files
        }
        
        super.init(name: name, type: type, hash: hash, parent: parent)
    }
    
    func addItem(item: FilesystemItem){
        items.append(item)
    }
    
    // Add colletion of items
    func addItems(items: [FilesystemItem]){
        self.items.append(contentsOf: items)
    }
    
    
}
