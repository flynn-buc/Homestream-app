//
//  PosterCollectionVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit
import Blueprints
import BlurredModalViewController

class MoviePosterCollectionVC: UIViewController, UICollectionViewDelegate {
    private let refreshControl = UIRefreshControl()
    private var rootFolder: Folder?
    var movieDataSource = MoviePosterDataSource(dataManager: DefaultDataManager())
    private var initialOrientationIsPortrait = false;
    
    @IBOutlet var posterCollectionView: PosterCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterCollectionView.dataSource = movieDataSource
        posterCollectionView.delegate = self
        
        posterCollectionView.addSubview(refreshControl)
        posterCollectionView.alwaysBounceVertical = true // required for refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // selector for refresh when collection view is pulled down
        getData(reloadData: true)
        
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
    
    private func getData(reloadData: Bool, onComplete: (()->())? = nil){
        movieDataSource.getData { (Response) in
            self.endRefresh()
            if (reloadData){
                self.posterCollectionView.reloadData()
            }
            onComplete?()
        } onError: { (error) in
            print(error)
            self.endRefresh()
        }
    }
    
    
    private func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    
    @objc private func refresh(reloadData: Bool, onComplete: (()->())? = nil){
        movieDataSource.refresh { (response) in
            self.getData(reloadData: reloadData) {
                onComplete?()
            }
        } onError: { (error) in
            self.endRefresh()
        }
    }
    
    @IBAction func favoritesButtonPressed(_ sender: FavoritesButton) {
        sender.set(isFavorite: !sender.getItem().isFavorite)
        movieDataSource.patch(data: sender.getItem())
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieVC = storyboard?.instantiateViewController(identifier: "movieVC") as? MovieVC,
           let blurredVC = storyboard?.instantiateViewController(identifier: "blurredVC") as? BlurredModalViewController{
            if let movieFile = movieDataSource.rootFolder?.items[indexPath.row] as? MovieFile{
                movieVC.initView(movie: movieFile, movieDataSource: movieDataSource)
                
                if UIDevice.current.userInterfaceIdiom == .pad{
                    blurredVC.modalPresentationStyle = .overCurrentContext
                    blurredVC.setViewControllerToDisplay(movieVC)
                    blurredVC.style = .systemThinMaterial
                    self.present(blurredVC, animated: false)
                    
                }else{
                    self.present(movieVC, animated: true, completion: nil)
                }
                
                if let cell = collectionView.cellForItem(at: indexPath) as? PosterCollectionCell{
                  
                }
            }
        }
    }
    
    
    @objc private func adjustLayout(){
        posterCollectionView.collectionViewLayout = posterCollectionView.getVerticalCellLayout()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let oldData = movieDataSource.rootFolder?.items
        DispatchQueue.main.async {
            let visibleCells = self.posterCollectionView.visibleCells
            if visibleCells.count > 0{
                let indexPath = self.posterCollectionView.indexPath(for: visibleCells[0])
                
                self.refresh(reloadData: false) {
                    if let indexPath = indexPath, let oldData = oldData, let newData = self.movieDataSource.rootFolder?.items{
                        self.posterCollectionView.reloadChanges(from: oldData, to: newData){
                            DispatchQueue.main.async {
                                self.posterCollectionView.reloadData()
                            }
                           
                            print("reloading here")
                            self.posterCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                        }
                    }
                }
            }
        }
    }
}
