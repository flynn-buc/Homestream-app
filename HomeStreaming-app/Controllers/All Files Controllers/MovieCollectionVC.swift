//
//  FolderController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import UIKit
import Differ

private let reuseIdentifier = "Cell"
typealias loadComplete = () -> Void

class MovieCollectionVC: UIViewController, UICollectionViewDelegate, VideoPlayerDelegate {
    
    @IBOutlet weak var folderCollection: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()


    private let filesDataSource =  FilesDataSource()
    private var currentPlayingMovie: File?
    
    override func viewDidLoad() {
        folderCollection.delegate = self
        folderCollection.dataSource = filesDataSource
        
        folderCollection.addSubview(refreshControl)
        folderCollection.alwaysBounceVertical = true // required for refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // selector for refresh when collection view is pulled down
        loadDataFromServer()
    }
    
    private func invalidQueryError(_ message: String) {
        print("Error: \(message)")
    }
    
    // Retrieve all data from server
    private func loadDataFromServer(reloadData: Bool = true, onLoadComplete: loadComplete? = nil){
        ClientService.instance.get() { (data) in
            self.filesDataSource.updateData(to: data) { (rootFolder) in
                if reloadData{
                    self.setupCollectionView(withFolder: rootFolder)
                }
            }
            self.endRefresh()
            if let loadComplete = onLoadComplete{
                loadComplete() // call completion if added
            }
        } onError: { (error) in
            self.invalidQueryError(error)
        }
    }
    
    //Refresh data, reload previous folder after refresh if it exists, or reload root folder
    @objc private func refresh() {
        let hash = filesDataSource.getCurrentFolder()?.hash
        ClientService.instance.refresh() { (response) in
            print(response)
            // load data from server, using completion to load root folder or current folder if it exists
            self.loadDataFromServer(reloadData: false) {
                if let hash = hash{
                    if let rootFolder = self.filesDataSource.getRootFolder(){
                        var folder: Folder
                        if hash == rootFolder.hash{
                            folder = rootFolder // skip searching if previous folder was root
                        }else{
                            print("In Other")
                            folder = self.findFolder(rootFolder.items, withHash: hash) ?? rootFolder
                        }
                        print("Found Folder: \(folder.name)")
                        self.setupCollectionView(withFolder: folder)
                    }
                }
            }
        } onError: { (error) in
            self.invalidQueryError(error)
            print(error)
            self.endRefresh()
        }
    }
    
    // Tell server to load video, then call VideoPlayerVC with
    // appropriate file info
    private func displayVideo(for file: File){
        let pathURL = "/\(pathAsURL(file.hash))" // convert file hash to URL
        ClientService.instance.play(file: file) { (serverFile) in
            print("Will Play: \(serverFile.name)")
            guard let videoPlayerVC = self.storyboard?.instantiateViewController(identifier: "videoPlayerVC") as? VideoPlayerVC else {
                print("failed")
                return
            }
            file.setPlaybackPosition(playbackPosition: serverFile.playbackPosition)
            file.setFavorite(favorite: serverFile.isFavorite)
            self.currentPlayingMovie = file
            videoPlayerVC.modalPresentationStyle = .fullScreen
            videoPlayerVC.modalTransitionStyle = .coverVertical
            videoPlayerVC.view.backgroundColor = UIColor.black
            videoPlayerVC.delegate = self
            self.present(videoPlayerVC, animated: true, completion: nil)
            videoPlayerVC.initPlayer(url: "\(pathURL)/Play/", fileHash: file.hash, beginningTimestamp: file.playbackPosition)
            print("Playing...: http://nissa.local:3004/\(file.hash)/Play/")
        } onError: { (message) in
            print("error: \(message)")
        }
    }
    
    func saveTimestamp(timestamp: Int, hash: Int){
        print("Here!")
        if let file = currentPlayingMovie{
            if hash == file.hash{
                file.setPlaybackPosition(playbackPosition: timestamp)
                print("Time stamp: \(timestamp)")
                ClientService.instance.patch(file: file)
            }
        }
    }
    
    //returns folder from given collection with hash, or nil if it doesn't exist
    private func findFolder(_ items: [FilesystemItem], withHash hash:Int) -> Folder?{
        for item in items{
            if let folder = item as? Folder{
                if folder.hash == hash{
                    return folder
                }else{
                    if let folder = findFolder(folder.items, withHash: hash){
                        return folder
                    }
                }
            }
        }
        return nil
    }
    
    private func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    //Setup collection view from subfolders found in provided folder
    private func setupCollectionView(withFolder folder: Folder){
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
    
    //Return path encoded as URL
    private func pathAsURL (_ pathURL: Any) -> String{
        return pathAsURL(fromString: "\(pathURL)")
    }
    
    //Return path from string encoded as URL
    private func pathAsURL(fromString path: String) -> String{
        return path.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }
}


//Etension for IBActions
extension MovieCollectionVC{
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        refresh()
    }
    
    @IBAction func folderBtnPressed(_ sender: FolderButton) {
        if (sender.type == .folder){ // show enclosing folder if button clicked was folder
            guard let currentFolder = filesDataSource.getCurrentFolder()?.items[sender.tag] as? Folder else{return}
            setupCollectionView(withFolder: currentFolder)
        }else if sender.type == .movie{ // handle displaying movie if button clicked was movie
            guard let fileToPlay = filesDataSource.getCurrentFolder()?.items[sender.tag] as? File else{return}
            displayVideo(for: fileToPlay)
        }
    }

    // if current folder has a parent, load parent folder (only root should fail here)
    @IBAction func backBtnPressed(_ sender: Any) {
        guard let parent = filesDataSource.getCurrentFolder()?.parent as? Folder else {return}
        setupCollectionView(withFolder: parent)
    }
    
    @IBAction func favoritesBtnPressed(_ sender: FavoritesButton) {
        sender.set(isFavorite: !sender.isFavorite())
        if let file = sender.getItem() as? File{
            ClientService.instance.patch(file: file)
        }
    }
}

extension MovieCollectionVC: UICollectionViewDelegateFlowLayout{
    //Adjust cell size for iphones
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize:CGSize = CGSize(width: 164, height: 152)
        if UIDevice.current.userInterfaceIdiom == .phone{
            cellSize = CGSize(width: 110, height: 103)
        }
        return cellSize
    }
}
