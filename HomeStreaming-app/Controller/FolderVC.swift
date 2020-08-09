//
//  FolderController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit
import Differ

private let reuseIdentifier = "Cell"
typealias loadComplete = () ->Void

class FolderVC: UIViewController {
    
    @IBOutlet weak var folderCollection: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()
    
    private var rootFolder: Folder? // represent root folder sent by server
    private var currentFolder: Folder? // represent currently selected folder
    
    override func viewDidLoad() {
        folderCollection.delegate = self
        folderCollection.dataSource = self
        
        folderCollection.addSubview(refreshControl)
        folderCollection.alwaysBounceVertical = true // required for refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // selector for refresh when collection view is pulled down
        loadDataFromServer()
    }
    
    fileprivate func invalidQueryError(_ message: String) {
        print("Error: \(message)")
    }
    
    // Updates data used to display folders
    // If reloadTable is nil or false, caller must update data manually
    private func updateData(to data: MessageData, reloadTable: Bool? = true){
        rootFolder = Folder(name: data.currentFolder, type: .folder, hash: data.folders.hash)
        rootFolder?.addItems(items: loadServerData(from_files: data.folders.files, parent: rootFolder!))
        rootFolder?.addItems(items: loadServerData(from_subfolders:data.folders.subfolders, parent: rootFolder!))
        
        if let rootFolder = rootFolder, let reloadTable = reloadTable{
            if (reloadTable){
                loadFolder(rootFolder)
            }
        }
    }
    
    //Recursively populate subfolder data
    private func loadServerData(from_subfolders serverfolders: [ServerSubfolder], parent: FilesystemItem) -> [Folder]{
        var folders: [Folder] = []
        for serverfolder in serverfolders{
            let newFolder = Folder(name: serverfolder.name, type: .folder, hash:serverfolder.hash, parent: parent)
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
            files.append(File(name: file.name, type: type, hash: file.hash, parent: parent))
        }
        return files
    }
    
    
    private func loadDataFromServer(reloadData: Bool? = true, onLoadComplete: loadComplete? = nil){
        ClientService.instance.get() { (data) in
            self.updateData(to: data, reloadTable: reloadData)
            self.endRefresh()
            if let loadComplete = onLoadComplete{
                loadComplete()
            }
        } onError: { (error) in
            self.invalidQueryError(error)
        }
    }
    
    //Refresh data, 
    @objc private func refresh() {
        let hash = currentFolder?.hash
        ClientService.instance.refresh() { (response) in
            print(response)
            self.loadDataFromServer(reloadData: false) {
                if let hash = hash{
                    if let rootFolder = self.rootFolder{
                        if hash == rootFolder.hash{
                            return;
                        }
                        _ = self.loadFolder(rootFolder.items, withHash: hash)
                    }
                }
            }
        } onError: { (error) in
            self.invalidQueryError(error)
            print(error)
            self.endRefresh()
        }
    }
    
    private func loadFile(path: Int){
        let pathURL = "/\(pathAsURL(path))"
        ClientService.instance.get(fileAt: pathURL) { (ServerFile) in
            print("Will Play: \(ServerFile.name)")
            guard let videoPlayerVC = self.storyboard?.instantiateViewController(identifier: "videoPlayerVC") as? VideoPlayerVC else {
                print("failed")
                return
            }
            self.present(videoPlayerVC, animated: true, completion: nil)
            videoPlayerVC.initPlayer(url: "\(pathURL)/Play/")
            print("Playing...: http://nissal.local:3004\(path)/Play/")
        } onError: { (message) in
            print("error: \(message)")
        }
    }
    
    private func loadFolder(_ items: [FilesystemItem], withHash hash:Int) -> Bool{
        for item in items{
            if let folder = item as? Folder{
                if folder.hash == hash{
                    self.loadFolder(folder)
                    print("Found hash: \(folder.name)")
                    return true;
                }else{
                    if loadFolder(folder.items, withHash: hash){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    private func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    private func loadFolder(_ folder: Folder){
        let oldFolder = currentFolder
        currentFolder = folder
        backBtn.isEnabled = currentFolder?.parent != nil
        if let currentFolder = currentFolder{
            self.navigationItem.title = currentFolder.name
            if let oldItems = oldFolder?.items {
                print(currentFolder.name)
                self.reloadChanges(from: oldItems, to: currentFolder.items)
            }else{
                self.folderCollection.reloadData()
            }
        }
    }
    
    func pathAsURL (_ pathURL: Int) -> String{
        return path(asURL: "\(pathURL)")
    }
    
    func path(asURL path: String) -> String{
        return path.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }
}


//Etension for IBActions
extension FolderVC{
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        refresh()
    }
    
    @IBAction func folderBtnPressed(_ sender: FolderButton) {
        if (sender.type == .folder){
            guard let currentFolder = currentFolder?.items[sender.tag] as? Folder else{return}
            loadFolder(currentFolder)
        }else if sender.type == .movie{
            guard let fileToPlay = currentFolder?.items[sender.tag] as? File else{return}
            loadFile(path: fileToPlay.hash)
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        guard let parent = currentFolder?.parent as? Folder else {return}
        loadFolder(parent)
    }
    
    @IBAction func favoritesBtnPressed(_ sender: FavoritesButton) {
        sender.set(isFavorite: !sender.isFavorite())
    }
}

extension FolderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
    
    //Animate cell refresh
    func reloadChanges<T: Collection>(from old: T, to new: T) where T.Element: Equatable {
        folderCollection.animateItemChanges(oldData: old, newData: new, updateData:{})
    }
    
    //Adjust cell size for iphone
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize:CGSize = CGSize(width: 164, height: 152)
        if UIDevice.current.userInterfaceIdiom == .phone{
            cellSize = CGSize(width: 110, height: 103)
        }
        return cellSize
    }
}
