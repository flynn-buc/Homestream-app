//
//  PosterPageVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/25/20.
//

import UIKit
import Parchment

class PosterPageVC: UINavigationController, PagingViewControllerDataSource {
    var movieVC: UIViewController!
    var tvshowVC: UIViewController!
    var favoritesVC: UIViewController!
    var pagingVC: PagingViewController!
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieStoryboard = UIStoryboard(name: "Posters", bundle: nil)
        
        if let vc = movieStoryboard.instantiateViewController(identifier: "posterCollectionVC") as? PosterCollectionVC{
            movieVC = vc
        }

        if let vc = movieStoryboard.instantiateViewController(identifier: "posterCollectionVC") as? PosterCollectionVC{
            tvshowVC = vc
        }

        if let vc = movieStoryboard.instantiateViewController(identifier: "posterCollectionVC") as? PosterCollectionVC{
            vc.movieDataSource = MoviePosterDataSource(dataManager: FavoritesDataManager())
            favoritesVC = vc
        }



        movieVC.title = "Movies"
        tvshowVC.title = "TV Shows"
        favoritesVC.title = "Favorites"

        self.navigationBar.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        self.navigationBar.isTranslucent = false

        controllers = [movieVC, tvshowVC, favoritesVC]

        pagingVC = PagingViewController()

        pagingVC.dataSource = self
        pagingVC.textColor = UIColor.gray
        pagingVC.selectedTextColor = UIColor.systemIndigo
        pagingVC.indicatorColor = UIColor.systemIndigo
        pagingVC.borderColor = UIColor.black
        pagingVC.backgroundColor = UIColor.black
        pagingVC.selectedBackgroundColor = UIColor.black
        pagingVC.includeSafeAreaInsets = false
        pagingVC.menuBackgroundColor = UIColor.black

        addChild(pagingVC)

        self.view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: margins.topAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        controllers.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return controllers[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: controllers[index].title ?? "no title")
    }
    
}
