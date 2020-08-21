//
//  FavoriteCollectionVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/18/20.
//

import UIKit

class FavoriteCollectionVC: MovieCollectionVC {
    override func viewDidLoad() {
        filesDataSource =  FilesDataSource(dataManager: FavoritesDataManager())
        super.viewDidLoad()
    }
}
