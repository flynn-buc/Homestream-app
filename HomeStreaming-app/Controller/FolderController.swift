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
    
   
    @IBOutlet weak var backBtn: UIBarButtonItem!
    private var folderNames: [String] = []
    private var currentPath: String = ""
    private var currentFolder: String = ""
    private var itemsClicked: [String] = []
    private var paths: [String] = []
    private var depth: Int = 0
    
    
    override func viewDidLoad() {
        folderCollection.delegate = self
        folderCollection.dataSource = self
        loadFolders(path:currentPath);
        backBtn.isEnabled = false
        
        paths.reserveCapacity(10)
        itemsClicked.reserveCapacity(10)
       
    }
    
    
    fileprivate func loadUIWithItems(_ response: MessageData, _ path: String) {
        self.folderNames = response.folders.subfolders;
        self.title = response.currentFolder
        self.folderCollection.reloadData()
        itemsClicked.append(response.currentFolder)
        
        if (path == ""){
            backBtn.isEnabled = false
        }else{
            backBtn.isEnabled = true
        }
        
        paths.append(path)
       
    }
    
    func loadFolders(path: String){
        ClientService.instance.getMessage(path: path) { (response) in
            self.loadUIWithItems(response, path)
            
        } onError: { (message) in
            print(message)
        }
        
        for folder in folderNames{
            print(folder)
        }
        
        
        
    }
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        //loadFolders(path: currentPath)
        folderCollection.reloadData()
        print("reload btn pressed")
    }
    
    @IBAction func folderBtnPressed(_ sender: UIButton) {
        depth += 1  
        let nextFolder = sender.title(for: .normal) ?? "Fucked up"
        print(nextFolder)
        backBtn.title = itemsClicked[depth - 1]
        currentPath = "\(sender.title(for: .normal)!.replacingOccurrences(of: " ", with: "%20"))/"
        print("current Path: \(currentPath)")
        loadFolders(path: currentPath)
        
    }

    
    @IBAction func backBtnPressed(_ sender: Any) {
        print(backBtn.title ?? "")
        
        paths.remove(at: depth)
        itemsClicked.remove(at: depth)
        depth -= 1
        loadFolders(path: paths[depth])
        itemsClicked.remove(at: depth)
        paths.remove(at: depth)
            
        print(paths)
    }
}




extension FolderController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as? FolderCell{
            cell.setup(name: folderNames[indexPath.row])
            return cell
        }
        
        return FolderCell()
    }
}
