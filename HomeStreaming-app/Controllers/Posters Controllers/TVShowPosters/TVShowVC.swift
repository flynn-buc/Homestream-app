//
//  TVShowVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/3/20.
//

import UIKit
import CachyKit
import BlurredModalViewController

class TVShowVC: UIViewController, VideoPlayerDelegate {

    
    private var tvShow: TVShow!
    private var canBeDismissed = true
    private var tableHeightConstraint: CGFloat = 450.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitleLabel: CustomUILabel!
    @IBOutlet weak var firstAirDateLabel: UILabel!
    @IBOutlet weak var lastAiredLabel: UILabel!
    @IBOutlet weak var nextToAirLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var numberOfSeasonsLabel: UILabel!
    @IBOutlet weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var seasonsTable: UITableView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var seasonsTableHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        castCollectionView.register(ActorCell.self, forCellWithReuseIdentifier: "tvActorCell")
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
    
        seasonsTable.register(SeasonsTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        seasonsTable.tableHeaderView?.backgroundColor = .clear
        
        seasonsTable.delegate = self
        seasonsTable.dataSource = self
        
       
        scrollView.delegate = self
        
        movieTitleLabel.text = tvShow.title
        statusLabel.text = tvShow.status
        runtimeLabel.text = "\(tvShow.runtime) min"
        languageLabel.text = tvShow.language
        numberOfSeasonsLabel.text = "\(tvShow.numberOfSeasons)"
        numberOfEpisodesLabel.text = "\(tvShow.numberOfEpisodes)"
        overviewLabel.text = tvShow.overview
        firstAirDateLabel.text = tvShow.firstAired
        lastAiredLabel.text = tvShow.lastAired
        nextToAirLabel.text = tvShow.nextToAir
        
        if (tvShow.image == "blank poster"){
            poster.image = UIImage(named: tvShow.image)
        }else{
            poster.load(url: URL(string: tvShow.image)!, placeholder: nil)
        }
        if tvShow.backdrop != ""{
            backdrop.load(url: URL(string: tvShow.backdrop)!, placeholder: nil)
        }

        
    }
    
    override func viewDidLayoutSubviews() {
        seasonsTableHeightConstraint.constant = seasonsTable.contentSize.height
    }
    
    
    func initView(tvShow: TVShow){
        self.tvShow = tvShow
    }
    
    func saveTimestamp(timestamp: Int, hash: Int) {
        
    }

}

extension TVShowVC: BlurredScrollableModalView{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        canBeDismissed = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        canBeDismissed = true
    }
    
    func canDismiss() -> Bool {
        if (scrollView.contentOffset.y <= 0){
            return true
        }
        return canBeDismissed
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canBeDismissed = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = backdrop.bounds.height
        let heightOffset = scrollView.contentOffset.y
        
        if (heightOffset <= 0){
            backgroundView.alpha = 0
        }else if heightOffset >= height{
            backgroundView.alpha = 1
        }else{
            backgroundView.alpha = heightOffset / (height - 30)
        }
    }
}


extension TVShowVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShow.seasons[tvShow.seasons.endIndex-1].cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvActorCell", for: indexPath) as? ActorCell {
            let cast = tvShow.seasons[tvShow.seasons.endIndex - 1].cast[indexPath.row]
            cell.initView(image: cast.image, name: cast.name, characterName: cast.character)
            return cell
        }
        
        return ActorCell()
    }
}


extension TVShowVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tvShow.seasons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SeasonsTableSectionHeaderView{
            let show = tvShow.seasons[section]
            view.setup(seasonNum: show.seasonNum, numberOfEpisodes: show.numOfEpisodes)
            return view
        }
        
        return SeasonsTableSectionHeaderView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell") as? SeasonCell{
            cell.initView(seasonNum: indexPath.section, collectionViewDataSource: SeasonCollectionViewDataSource(season: tvShow.seasons[indexPath.section], section: indexPath.section))
            return cell
        }
        
        return SeasonCell()
    }
}
