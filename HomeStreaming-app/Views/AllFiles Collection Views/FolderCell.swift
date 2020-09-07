//
//  FolderCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit
/// Define a cell to display either video files or sub folders in a collection view
/// Uses buttons as cells --- SHOULD BE CHANGED
class FolderCell: UICollectionViewCell {
    
    private let extensionList = [".mp4", ".m4a", ".m4v", ".f4v", ".fa4", ".m4b", ".m4r", ".f4b", ".mov", ".3gp",
                         ".3gp2", ".3g2", ".3gpp", ".3gpp2", ".ogg", ".oga", ".ogv", ".ogx", ".wmv", ".wma",
                         ".webm", ".flv", ".avi", ".mpg", ".mkv"]
    private let subtitleExt = ".srt"

   
    @IBOutlet weak var folderButton: FolderButton!
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var favoritesButton: FavoritesButton!
    
    /// Setup the cell with the specified filesystem Item and index
    /// Displays either a folder icon, a video icon, or a subtitle icon, along with a favorite button
    /// - Parameter filesystemItem: Represents either a file or a folder
    /// - Parameter index: Int value of the index in the collection of the item
    func setup(filesystemItem: inout FilesystemItem, index: Int){
        
        if let file = filesystemItem as? File{
            configure(file: file)
        }
        if let folder = filesystemItem as? Folder{
            configure(folder: folder)
        }
        
        folderButton.type = filesystemItem.type;
        folderName.text = filesystemItem.name
        folderButton.setTitle(filesystemItem.name, for: .normal)
        folderButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        folderButton.tag = index
        favoritesButton.setItem(item: filesystemItem)
        favoritesButton.set(isFavorite: filesystemItem.isFavorite)
    }
    
    private func configure(folder: Folder){
        folderButton.setImage(UIImage(named: "folder.png"), for: .normal)
        folderButton.setImage(UIImage(named: "folder_highlighted.png"), for: .selected)

        folderButton.isEnabled = true
    }
    
    private func configure(file: File){
        var imageName = "videoFile.png"
        if (file.type == .subtitle){
            imageName = "subtitle.png"
        }

        folderButton.setImage(UIImage(named: imageName), for: .normal)
        folderButton.adjustsImageWhenDisabled = false
    }
}
