//
//  TVShowPosterCollection.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/2/20.
//

import UIKit
import BlurredModalViewController

class TVShowPosterCollection: UIViewController, UICollectionViewDelegate {

    private let refreshControl = UIRefreshControl()
    private var rootFolder: Folder?
    var tvShowDataSource = TVShowDataSource(dataManager: TVShowDataManager())
    private var initialOrientationIsPortrait = false;
    
    @IBOutlet var posterCollectionView: PosterCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterCollectionView.dataSource = tvShowDataSource
        posterCollectionView.delegate = self
        
        posterCollectionView.addSubview(refreshControl)
        posterCollectionView.alwaysBounceVertical = true // required for refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // selector for refresh when collection view is pulled down
        //getData(reloadData: true)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
       NotificationCenter.default.addObserver(self, selector: #selector(adjustLayout), name: UIDevice.orientationDidChangeNotification, object: nil)
        DispatchQueue.main.async {
            self.adjustLayout()
        }
        
        getData(reloadData: true){
            self.posterCollectionView.reloadData()
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        getData(reloadData: true){
            self.posterCollectionView.reloadData()
            print("Data reloaded")
        }
        
        self.navigationController?.tabBarItem.image = UIImage(systemName: "tv.fill")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.image = UIImage(systemName: "tv")
    }
    
    private func getData(reloadData: Bool, onComplete: (()->())? = nil){
        tvShowDataSource.getData { (response) in
            self.endRefresh()
            if (reloadData){
                self.posterCollectionView.reloadData()
            }
            onComplete?()
        } onError: { (error) in
            print(error)
            print("There,...")
            self.endRefresh()
        }
    }
    
    
    @objc private func adjustLayout(){
        posterCollectionView.collectionViewLayout = posterCollectionView.getHorizontalCellLayout()
    }
    
    private func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    @objc func refresh(){
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tvShowVC = storyboard?.instantiateViewController(identifier: "tvShowVC") as? TVShowVC,
           let blurredVC = storyboard?.instantiateViewController(identifier: "blurredVC") as? BlurredModalViewController{
            if let show = tvShowDataSource.shows?[indexPath.row]{
                tvShowVC.initView(tvShow: show)
                if UIDevice.current.userInterfaceIdiom == .pad{
                    blurredVC.modalPresentationStyle = .overCurrentContext
                    blurredVC.setViewControllerToDisplay(tvShowVC)
                    blurredVC.style = .systemThinMaterial
                    self.present(blurredVC, animated: false)
                    
                }else{
                    self.present(tvShowVC, animated: true, completion: nil)
                }
            }
        }
    }
}
