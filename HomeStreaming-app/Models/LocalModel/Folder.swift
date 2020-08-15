//
//  Folder.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/9/20.
//

import Foundation

//Folder object, olds an array of Filesystem
class Folder: FilesystemItem{
    public private(set) var items: [FilesystemItem] = []
    
    init(name: String, type: FileType, hash: Int, isFavorite: Bool, parent: FilesystemItem? = nil, files: [FilesystemItem]? = nil){
        if let files = files{
            self.items = files
        }
        
        super.init(name: name, type: type, hash: hash, isFavorite: isFavorite, parent: parent)
    }
    
    func addItem(item: FilesystemItem){
        items.append(item)
    }
    
    // Add colletion of items
    func addItems(items: [FilesystemItem]){
        self.items.append(contentsOf: items)
    }
}
