//
//  FolderController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit
import Differ

private let reuseIdentifier = "Cell"

class FolderVC: UIViewController {
    
    @IBOutlet weak var folderCollection: UICollectionView!
    
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    private var folders: [Item] = []
    private var currentPath: String = ""
    private var currentFolder: String = ""
    private var itemsClicked: [String] = []
    private var paths: [String] = []
    private var depth: Int = 0
    
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        folderCollection.delegate = self
        folderCollection.dataSource = self
        loadFolders(path:currentPath)
        backBtn.isEnabled = false
        
        folderCollection.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.folderCollection.alwaysBounceVertical = true
    }
    
    
    fileprivate func loadUIWithItems(_ response: MessageData, _ path: String) {
        
        let oldData = folders
        
        var tempFolders = [Item]()
        for folderName in response.folders.subfolders{
            tempFolders.append(Item(name: folderName, type: .folder))
        }
        
        self.navigationItem.title = response.currentFolder
        
        itemsClicked.append(response.currentFolder)
        
        if (path == ""){
            backBtn.isEnabled = false
            paths = [""]
        }else{
            backBtn.isEnabled = true
        }
        
        
        
        for file in response.files.files{
            if (file.contains(".srt")){
                tempFolders.append(Item(name: file, type: .subtitle))
            }else{
                tempFolders.append(Item(name: file, type: .movie))
            }
        }
        
        folders = tempFolders
        self.reloadChanges(from: oldData, to: tempFolders)
    }
    
    func loadFolders(path: String){
        ClientService.instance.get(foldersAndFilesAt: path) { (response) in
            self.loadUIWithItems(response, path)
            
        } onError: { (message) in
            print(message)
        }
        
        for folder in folders{
            print(folder)
        }
    }
    
    func displayFile(path: String){
        ClientService.instance.get(fileAt: path) { (response) in
            let alert = UIAlertController(title: "Would Play File", message: response.file, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
            guard let videoPlayerVC = self.storyboard?.instantiateViewController(identifier: "videoPlayerVC") as? VideoPlayerVC else {
                print("failed")
                return
            }
            
            print("Path to play:: \(path)")
            self.present(videoPlayerVC, animated: true, completion: nil)
            videoPlayerVC.initPlayer(url: "http://nissa.local:3004\(path)/Play/")
            
        } onError: { (message) in
            print(message)
        }
    }
    
    
     @objc private func refresh() {
        ClientService.instance.refresh { (response) in
            print(response)
            self.loadFolders(path: self.currentPath)
            self.endRefresh()
            
        } onError: { (error) in
            print(error)
        }
        print("reload btn pressed")
    }
    
    private func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        refresh()
    }
    
    @IBAction func folderBtnPressed(_ sender: FolderButton) {
        if sender.type == .folder {
            depth += 1
            let nextFolder = sender.title(for: .normal) ?? "Fucked up"
            print(nextFolder)
            currentPath = "\(currentPath)/\(path(asURL: nextFolder))"
            print("current Path: \(currentPath)")
            paths.append(currentPath)
            loadFolders(path: currentPath)
            print(paths)
        } else{
            if sender.type == .movie{
                var pathToDisplay = currentPath
                pathToDisplay.append("/")
                pathToDisplay.append(path(asURL: sender.title(for: .normal) ?? "Fucked up"))
                displayFile(path: pathToDisplay)
            }
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        print(backBtn.title ?? "")
        paths.remove(at: depth)
        itemsClicked.remove(at: depth)
        depth -= 1
        currentPath = paths[depth]
        loadFolders(path: currentPath)
        print(paths)
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
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as? FolderCell{
            cell.setup(folder: &folders[indexPath.row])
            print("\(folders[indexPath.row].name) : favorite? \(folders[indexPath.row].isFavorite)")
            return cell
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
