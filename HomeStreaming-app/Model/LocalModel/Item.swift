//
//  Item.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/17/20.
//

import Foundation
struct Item: Equatable {
    let name: String
    let type: FileType
    var isFavorite = false
    
    init(name: String, type: FileType){
        self.name = name
        self.type = type
    }
    
    
    static func == (lhs: Item, rhs: Item) -> Bool{
        return lhs.name == rhs.name && lhs.type == rhs.type
    }
}
