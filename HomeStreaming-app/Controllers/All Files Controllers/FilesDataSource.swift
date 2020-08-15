//
//  FilesDataSource.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import UIKit

class FilesDataSource: NSObject, UICollectionViewDataSource {
    private var rootFolder: Folder? // represent root folder sent by server
    private var currentFolder: Folder? // represent currently selected folder
    
    
    // Updates data used to display folders
    // If reloadTable is nil or false, caller must update data manually
    func updateData(to data: MessageData, completed: ((Folder)->Void) = {(folder: Folder) -> Void in}){
        rootFolder = Folder(name: data.currentFolder, type: .folder, hash: data.folders.hash, isFavorite: data.folders.isFavorite)
        rootFolder?.addItems(items: loadServerData(from_files: data.folders.files, parent: rootFolder!))
        rootFolder?.addItems(items: loadServerData(from_subfolders:data.folders.subfolders, parent: rootFolder!))
        
        if let rootFolder = rootFolder{
            completed(rootFolder)
            
        }
    }
    
    //Recursively populate subfolder data
    private func loadServerData(from_subfolders serverfolders: [ServerSubfolder], parent: FilesystemItem) -> [Folder]{
        var folders: [Folder] = []
        for serverfolder in serverfolders{
            let newFolder = Folder(name: serverfolder.name, type: .folder, hash:serverfolder.hash, isFavorite: serverfolder.isFavorite, parent: parent)
            newFolder.addItems(items: loadServerData(from_subfolders: serverfolder.subfolders, parent: newFolder))
            newFolder.addItems(items: loadServerData(from_files: serverfolder.files, parent: newFolder))
            folders.append(newFolder)
        }
        return folders
    }
    
    //Populate file Data
    private func loadServerData(from_files serverFiles: [ServerFile], parent: FilesystemItem) -> [File]{
        var files: [File] = []
        for file in serverFiles{
            let type: FileType = file.name.contains(".srt") ? .subtitle: .movie
            files.append(File(name: file.name, type: type, hash: file.hash, isFavorite: file.isFavorite, parent: parent, playbackPosition: file.playbackPosition))
        }
        return files
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFolder?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as? FolderCell{
            if var item = currentFolder?.items[indexPath.row]{
                cell.setup(filesystemItem: &item, index: indexPath.row)
                return cell
            }
        }
        return FolderCell()
    }
    
    func getCurrentFolder()->Folder?{
        return currentFolder
    }
    
    func getRootFolder()->Folder?{
        return rootFolder
    }
    
    func updateRootFolder(rootFolder: Folder){
        self.rootFolder = rootFolder
    }
    
}
