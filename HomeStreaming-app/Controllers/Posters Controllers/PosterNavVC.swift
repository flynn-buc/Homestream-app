//
//  PosterNavVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/31/20.
//

import UIKit
import Parchment
import Blueprints

class PosterNavVC: UINavigationController, PagingViewControllerDataSource{
    var pagingVC: PagingViewController!
    
    internal var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pagingVC = PagingViewController()
        
        self.navigationBar.backgroundColor = UIColor.systemBackground
        self.view.backgroundColor = UIColor.systemBackground
        self.navigationBar.isTranslucent = false

        guard let accentColor = UIColor(named: "AccentColor") else{return}
        
        pagingVC.dataSource = self
        pagingVC.textColor = UIColor.gray
        pagingVC.selectedTextColor = accentColor
        pagingVC.indicatorColor = accentColor
        pagingVC.borderColor = UIColor.systemGray6
        pagingVC.backgroundColor = UIColor.systemBackground
        pagingVC.selectedBackgroundColor = UIColor.systemBackground
        pagingVC.includeSafeAreaInsets = true
        pagingVC.menuBackgroundColor = UIColor.systemBackground

        addChild(pagingVC)

        self.view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
