//
//  PosterCollectionVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit
import Blueprints

class PosterCollectionVC: UIViewController, UICollectionViewDelegate {
    
    let maxHeightIpad:CGFloat = 400
    let minHeightIpad: CGFloat = 300
    
    let ratio: CGFloat = 406/256
    
    let currentCellHeight: CGFloat = 200
    let currentCellWeidth: CGFloat = 100
    
    private let refreshControl = UIRefreshControl()
    private var rootFolder: Folder?
    private let movieDataSource = MoviePosterDataSource(dataManager: DefaultDataManager())
    private var initialOrientationIsPortrait = false;
    
    @IBOutlet var posterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem.image = UIImage(systemName: "film.fill")
        self.navigationController?.tabBarItem.title = "Media"
        
        posterCollectionView.dataSource = movieDataSource
        posterCollectionView.delegate = self
        
        posterCollectionView.addSubview(refreshControl)
        posterCollectionView.alwaysBounceVertical = true // required for refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // selector for refresh when collection view is pulled down
        getData()
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustLayout), name: UIDevice.orientationDidChangeNotification, object: nil)
        DispatchQueue.main.async {
            self.adjustLayout()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    private func getData(){
        movieDataSource.getData { (Response) in
            self.endRefresh()
            self.posterCollectionView.reloadData()
        } onError: { (error) in
            print(error)
            self.endRefresh()
        }
    }
    
    private func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    
    @objc private func refresh(){
        movieDataSource.refresh { (response) in
            self.getData()
        } onError: { (error) in
            self.endRefresh()
        }
    }
    
    @IBAction func favoritesButtonPressed(_ sender: FavoritesButton) {
        sender.set(isFavorite: !sender.getItem().isFavorite)
        movieDataSource.patch(data: sender.getItem())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieVC = storyboard?.instantiateViewController(identifier: "movieVC") as? MovieVC{
            if let movieFile = movieDataSource.rootFolder?.items[indexPath.row] as? MovieFile{
                movieVC.initView(movie: movieFile, movieDataSource: movieDataSource)
                self.present(movieVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func adjustLayout(){
        let isPortrait = self.isPortrait()
        var itemsPerRow:CGFloat = 3.0
        var height: CGFloat = 220
        var interItemSpacing: CGFloat = 10
        var lineSpacing: CGFloat = 10
        var insets = EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            if isPortrait{
                itemsPerRow = 3.0
                lineSpacing = 30
            }else{
                itemsPerRow = 4.0
                height = 250
                interItemSpacing = 5
                insets.left = 5
                insets.right = 5
            }
        }else{
            height = 285
            if isPortrait{
                print("Here!!")
                itemsPerRow = 5.0
            }else{
                itemsPerRow = 6.0
                print("There")
            }
        }
        
        let blueprintLayout: VerticalBlueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            height: height,
            minimumInteritemSpacing: interItemSpacing,
            minimumLineSpacing: lineSpacing,
            sectionInset: insets,
            stickyHeaders: true,
            stickyFooters: false
        )
        posterCollectionView.collectionViewLayout = blueprintLayout
        print("is Portrait?!\(isPortrait)\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    }
    
    private func isPortrait()->Bool{
        let size = self.view.bounds.size
        return (size.width < size.height)
    }
}
