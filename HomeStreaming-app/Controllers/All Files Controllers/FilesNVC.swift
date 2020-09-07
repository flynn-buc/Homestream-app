//
//  FilesNVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/19/20.
//

import UIKit

class FilesNVC: UINavigationController {
    let filesDataSource = FilesDataSource(dataManager: DefaultDataManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
