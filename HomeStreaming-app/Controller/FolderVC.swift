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
    
    private var rootFolder: Folder?
    private var currentFolder: Folder?
    
    override func viewDidLoad() {
        folderCollection.delegate = self
        folderCollection.dataSource = self
        folderCollection.addSubview(refreshControl)
        folderCollection.alwaysBounceVertical = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        loadItems()
    }
    
    fileprivate func invalidQueryError(_ message: String) {
        print("Error: \(message)")
    }
    
    private func updateData(to data: MessageData, reloadTable: Bool? = true){
        rootFolder = Folder(name: data.currentFolder, type: .folder, hash: data.folders.hash)
        rootFolder?.addItems(items: loadFiles(serverFiles: data.folders.files, parent: rootFolder!))
        rootFolder?.addItems(items: loadSubfolders(serverfolders: data.folders.subfolders, parent: rootFolder!))
        
        if let rootFolder = rootFolder, let reloadTable = reloadTable{
            if (reloadTable){
                loadFolder(rootFolder)
            }
        }
    }
    
    private func loadSubfolders(serverfolders: [ServerSubfolder], parent: Item) -> [Folder]{
        var folders: [Folder] = []
        for serverfolder in serverfolders{
            let newFolder = Folder(name: serverfolder.name, type: .folder, hash:serverfolder.hash, parent: parent)
            newFolder.addItems(items: loadSubfolders(serverfolders: serverfolder.subfolders, parent: newFolder))
            newFolder.addItems(items: loadFiles(serverFiles: serverfolder.files, parent: newFolder))
            folders.append(newFolder)
        }
        return folders
    }
    
    private func loadFiles(serverFiles: [ServerFile], parent: Item) -> [Item]{
        var files: [Item] = []
        for file in serverFiles{
            let type: FileType = file.name.contains(".srt") ? .subtitle: .movie
            files.append(Item(name: file.name, type: type, hash: file.hash, parent: parent))
        }
        return files
    }
    
    
    private func loadItems(reloadData: Bool? = true, onLoadComplete: loadComplete? = nil){
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
    
    @objc private func refresh() {
        let hash = currentFolder?.hash
        ClientService.instance.refresh() { (response) in
            print(response)
            self.loadItems(reloadData: false) {
                if let hash = hash{
                    if let rootFolder = self.rootFolder{
                        if hash == rootFolder.hash{
                            return;
                        }
                        self.loadFolder(rootFolder.items, withHash: hash)
                    }
                }
            }
        } onError: { (error) in
            self.invalidQueryError(error)
            print(error)
            self.endRefresh()
        }
    }
    
    private func loadFolder(_ items: [Item], withHash hash:Int) -> Bool{
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
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        refresh()
    }
    
    @IBAction func folderBtnPressed(_ sender: FolderButton) {
        if (sender.type == .folder){
            guard let currentFolder = currentFolder?.items[sender.tag] as? Folder else{return}
            loadFolder(currentFolder)
        }else if sender.type == .movie{
            guard let fileToPlay = currentFolder?.items[sender.tag] as? Item else{return}
            loadFile(path: fileToPlay.hash)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        guard let parent = currentFolder?.parent as? Folder else {return}
        loadFolder(parent)
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
    
    func pathAsURL (_ pathURL: Int) -> String{
        return path(asURL: "\(pathURL)")
    }
    
    func pathAsURL(_ pathURL: String) -> String{
        return pathURL.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
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
    
    @IBAction func favoritesBtnPressed(_ sender: FavoritesButton) {
        sender.set(isFavorite: !sender.isFavorite())
    }
    
    
    func path(asURL path: String) -> String{
        return path.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }
}

extension FolderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFolder?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as? FolderCell{
            if var item = currentFolder?.items[indexPath.row]{
                cell.setup(folder: &item, index: indexPath.row)
                //            print("\(folders[indexPath.row].name) : favorite? \(folders[indexPath.row].isFavorite)")
                return cell
            }
        }
        return FolderCell()
    }
    
    func reloadChanges<T: Collection>(from old: T, to new: T) where T.Element: Equatable {
        folderCollection.animateItemChanges(oldData: old, newData: new, updateData:{})
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let device = UIDevice.current.model
        var cellSize:CGSize = CGSize(width: 164, height: 152)
        if (device == "iPhone" || device == "iPhone Simulator") {
            cellSize = CGSize(width: 110, height: 103)
        }
        return cellSize
    }
}
