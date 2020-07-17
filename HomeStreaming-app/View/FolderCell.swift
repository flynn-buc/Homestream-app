//
//  FolderCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit

class FolderCell: UICollectionViewCell {

   
    @IBOutlet weak var folderButton: UIButton!
    @IBOutlet weak var folderName: UILabel!
    
    func setup(name: String){
        folderButton.setImage(UIImage(named: "folder.png"), for: .normal)
        folderButton.setTitle(name, for: .normal)
        folderButton.setImage(UIImage(named: "folder_highlighted.png"), for: .selected)
        folderName.text = name
    }
}
