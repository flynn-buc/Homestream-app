//
//  FolderCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit

class FolderCell: UICollectionViewCell {

    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var folderName: UILabel!
    
    func setup(name: String){
        folderImageView.image = UIImage(named: "folder.png")
        folderName.text = "Movie Name: \(name)"
    }
}
