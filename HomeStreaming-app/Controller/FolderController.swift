//
//  FolderController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit

private let reuseIdentifier = "Cell"

class FolderController: UIViewController {

    @IBOutlet weak var folderCollection: UICollectionView!
    
    override func viewDidLoad() {
        folderCollection.delegate = self
        folderCollection.dataSource = self
    }
 }

extension FolderController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as? FolderCell{
            cell.setup(name: "\(indexPath.row)")
            return cell
        }
        
    
        return FolderCell()
    }
}
