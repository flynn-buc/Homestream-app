//
//  FavoritesButton.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/18/20.
//

import UIKit

/// Defines a favorite button with two states, capable of changing state and updating to ensure it matches the underlying item's favorite state
class FavoritesButton: UIButton {
    private var item: FilesystemItem!
    
    func refresh(){
        set(isFavorite: item.isFavorite)
    }
    
    func setItem(item: FilesystemItem){
        self.item = item
    }
    
    func getItem()->FilesystemItem{
        return self.item
    }
    
    func set(isFavorite: Bool){
        item.setFavorite(favorite: isFavorite)
        if (isFavorite){
            self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            self.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func isFavorite()->Bool{
        return item.isFavorite
    }
}
