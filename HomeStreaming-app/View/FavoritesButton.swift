//
//  FavoritesButton.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/18/20.
//

import UIKit

class FavoritesButton: UIButton {
    private var item: Item!
    
    func refresh(){
        set(isFavorite: item.isFavorite)
    }
    
    func setItem(item: inout Item){
        self.item = item
    }
    
    func getItem()->Item{
        return self.item
    }
    
    func set(isFavorite: Bool){
        item.isFavorite = isFavorite
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
