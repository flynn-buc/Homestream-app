//
//  Item.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/17/20.
//

import Foundation
class Item: Equatable {
    let name: String
    let type: FileType
    var isFavorite = false
    let parent: Item?
    let hash: Int
    
    init(name: String, type: FileType, hash: Int, parent: Item? = nil){
        self.name = name
        self.type = type
        self.parent = parent
        self.hash = hash
    }
    
    
    static func == (lhs: Item, rhs: Item) -> Bool{
        return lhs.name == rhs.name && lhs.type == rhs.type
    }
}

class Folder: Item{
    public private(set) var items: [Item] = []
    
    init(name: String, type: FileType, hash: Int, parent: Item? = nil, files: [Item]? = nil){
        if let files = files{
            self.items = files
        }
        
        super.init(name: name, type: type, hash: hash, parent: parent)
    }
    
    func addItem(item: Item){
        items.append(item)
    }
    
    func addItems(items: [Item]){
        self.items.append(contentsOf: items)
    }
    
    
}
