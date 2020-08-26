//
//  PosterPageVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/25/20.
//

import UIKit
import Parchment

class PosterPageVC: UINavigationController, PagingViewControllerDataSource {

    
    
    var firstVC: UIViewController!
    var secondVC: UIViewController!
    var thirdVC: UIViewController!
    var pagingVC: PagingViewController!
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage(systemName: "film.fill")
        self.tabBarItem.title = "Media"
        
        if let vc = storyboard?.instantiateViewController(identifier: "posterCollectionVC") as? PosterCollectionVC{
            firstVC = vc
        }
        
        if let vc = storyboard?.instantiateViewController(identifier: "posterCollectionVC") as? PosterCollectionVC{
            secondVC = vc
        }
        
        if let vc = storyboard?.instantiateViewController(identifier: "posterCollectionVC") as? PosterCollectionVC{
            thirdVC = vc
        }
        
        
        
        firstVC.title = "Movies"
        secondVC.title = "TV Shows"
        thirdVC.title = "Favorites"
        
        self.navigationBar.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        self.navigationBar.isTranslucent = false
        
        controllers = [firstVC, secondVC, thirdVC]
        
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
        
        
        
        
        // Do any additional setup after loading the view.
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
