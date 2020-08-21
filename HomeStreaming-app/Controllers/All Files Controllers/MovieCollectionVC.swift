//
//  MovieCollection.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 7/16/20.
// Responsible for handling actions from user interface, passing data requests to DataSource, and displaying changes back on interface

import UIKit
import NVActivityIndicatorView

private let reuseIdentifier = "Cell"
typealias loadComplete = () -> Void

class MovieCollectionVC: UIViewController, VideoPlayerDelegate {
    
    @IBOutlet weak var folderCollection: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()

    internal var filesDataSource: FilesDataSource!
    private let collectionViewDelegateLayout = CollectionViewDelegateWithLayout()
    private var currentPlayingMovie: File?
    private var currentTitle: String?
    private var activityView: NVActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        if filesDataSource != nil{
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navVC = self.navigationController as? FilesNVC{
            filesDataSource = navVC.filesDataSource
        }else if let navVC = self.navigationController as? FavoritesNavVC {
            filesDataSource = navVC.filesDataSource
            currentTitle = "Favorites"
        }
        folderCollection.dataSource = filesDataSource
        folderCollection.delegate = collectionViewDelegateLayout
        folderCollection.addSubview(refreshControl)
        folderCollection.alwaysBounceVertical = true // required for refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // selector for refresh when collection view is pulled down
        
        let frame = CGRect(x: (self.view.frame.size.width - 80)/2, y: (self.view.frame.size.height - 80)/2, width: 80, height: 80)
        activityView = NVActivityIndicatorView(frame:frame, type: .ballSpinFadeLoader, color: .systemIndigo)
        self.view.addSubview(activityView)
        loadDataFromServer()
    }
    
    func configure(){
        
    }
    
    private func invalidQueryError(_ message: String) {
        print("Error: \(message)")
    }
    
    // Retrieve all data from server
    private func loadDataFromServer(reloadData: Bool = true, onLoadComplete: loadComplete? = nil){
        filesDataSource.getData { (folder) in
            if let folder = folder as? Folder{
                self.setupCollectionView(withFolder: folder)
            }
            self.endRefresh()
            if let loadComplete = onLoadComplete{
                loadComplete()// call completion if added
            }
        } onError: { (error) in
            self.invalidQueryError("\(error)")
            self.endRefresh()
        }
    }
    
    //Refresh data, reload previous folder after refresh if it exists, or reload root folder
    @objc private func refresh() {
        let hash = filesDataSource.currentFolder?.hash
        filesDataSource.refresh { (response) in
            if let response = response as? String{
                print("Refreshed! \(response)")
                self.loadDataFromServer(reloadData: false) {
                    if let hash = hash{
                        if let rootFolder = self.filesDataSource.rootFolder{
                            var folder: Folder
                            if hash == rootFolder.hash{
                                folder = rootFolder // skip searching if previous folder was root
                            }else{
                                folder = rootFolder.findFolder(withHash: hash) ?? rootFolder
                            }
                            self.setupCollectionView(withFolder: folder)
                        }
                    }
                }
            }else{
                print("Refreshed, but return type uknown: \(response)")
            }
        } onError: { (response) in
            self.endRefresh()
            print("Error here: \(response)")
        }
    }
    
    // Tell server to load video, then call VideoPlayerVC with
    // appropriate file info
    private func displayVideo(for file: File){
        let pathURL = "/\(String.pathAsURL(file.hash))" // convert file hash to URL
        activityView.startAnimating()
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
            self.activityView.stopAnimating()
            self.present(videoPlayerVC, animated: true, completion: nil)
            videoPlayerVC.initPlayer(url: "\(pathURL)/Play/", fileHash: file.hash, beginningTimestamp: file.playbackPosition)
            print("Playing...: http://nissa.local:3004/\(file.hash)/Play/")
        } onError: { (message) in
            print("error: \(message)")
            self.activityView.stopAnimating()
        }
    }
    
    func saveTimestamp(timestamp: Int, hash: Int){
        if let file = currentPlayingMovie{
            if hash == file.hash{
                file.setPlaybackPosition(playbackPosition: timestamp)
                print("Time stamp: \(timestamp)")
                filesDataSource.patch(data: file)
            }
        }
    }
    
    private func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    //Setup collection view from subfolders found in provided folder
    private func setupCollectionView(withFolder folder: Folder){
        backBtn.isEnabled = folder.parent != nil
        let oldFolder = filesDataSource.currentFolder
        filesDataSource.updateCurrentFolder(to: folder)
        if let currentFolder = filesDataSource.currentFolder{
            self.navigationItem.title = currentFolder.name
            if let oldItems = oldFolder?.items {
                print(currentFolder.name)
                folderCollection.reloadChanges(from: oldItems, to: currentFolder.items)
            }else{
                self.folderCollection.reloadData()
            }
        }
    }
}

//Etension for IBActions
extension MovieCollectionVC{
    @IBAction func reloadBtnPressed(_ sender: Any) {
        refresh()
    }
    @IBAction func folderBtnPressed(_ sender: FolderButton) {
        if (sender.type == .folder){ // show enclosing folder if button clicked was folder
            guard let currentFolder = filesDataSource.currentFolder?.items[sender.tag] as? Folder else{return}
            setupCollectionView(withFolder: currentFolder)
        }else if sender.type == .movie{ // handle displaying movie if button clicked was movie
            guard let fileToPlay = filesDataSource.currentFolder?.items[sender.tag] as? File else{return}
            displayVideo(for: fileToPlay)
        }
    }

    // if current folder has a parent, load parent folder (only root should fail here)
    @IBAction func backBtnPressed(_ sender: Any) {
        guard let parent = filesDataSource.currentFolder?.parent as? Folder else {return}
        setupCollectionView(withFolder: parent)
    }
    
    @IBAction func favoritesBtnPressed(_ sender: FavoritesButton) {
        sender.set(isFavorite: !sender.isFavorite())
        filesDataSource.patch(data: sender.getItem())
    }
}
