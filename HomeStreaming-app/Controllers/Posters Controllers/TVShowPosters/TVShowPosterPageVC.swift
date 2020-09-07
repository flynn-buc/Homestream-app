import UIKit
import Parchment

class TVShowPosterPageVC: PosterNavVC {
    var showVC: UIViewController!
    var favoritesVC: UIViewController!
    
    override func viewDidLoad() {
        let tvStoryboard = UIStoryboard(name: "TVShowPosters", bundle: nil)
        
        if let vc = tvStoryboard.instantiateViewController(identifier: "showPosterCollectionVC") as? TVShowPosterCollection{
            showVC = vc
        }
        
        if let vc = tvStoryboard.instantiateViewController(identifier: "showPosterCollectionVC") as? TVShowPosterCollection{
            favoritesVC = vc
        }
        
        showVC.title = "TV Shows"
        favoritesVC.title = "Favorites"
        
        controllers = [showVC, favoritesVC]
        
        super.viewDidLoad()
    }
}
