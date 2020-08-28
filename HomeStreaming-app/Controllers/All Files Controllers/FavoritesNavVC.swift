//
//  FavoritesNavVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/19/20.
//

import UIKit

class FavoritesNavVC: UINavigationController {

    
    let filesDataSource = FilesDataSource(dataManager: FavoritesDataManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
