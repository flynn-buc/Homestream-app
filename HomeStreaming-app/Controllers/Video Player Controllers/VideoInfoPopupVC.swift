//
//  VideoInfoVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/12/20.
//

import UIKit

class VideoInfoPopupVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var infoCollectionView: UICollectionView!
    
    var menuItems = [[String]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = infoCollectionView.backgroundColor
        self.popoverPresentationController?.permittedArrowDirections = .up
        infoCollectionView.dataSource = self
        infoCollectionView.delegate = self
        if let flowLayout = infoCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }
    }
    
    
    

    func initView(player: VLCMediaPlayer){
        
        guard let media = player.media else{return}
        
        //Resolution:
        var resolutionStr = ""
        
        for track in media.tracksInformation{
            if let track = track as? NSDictionary{
                if track[VLCMediaTracksInformationType] as? String  == VLCMediaTracksInformationTypeVideo{
                    resolutionStr = "\(track[VLCMediaTracksInformationVideoWidth]!) x \(track[VLCMediaTracksInformationVideoHeight]!)"
                    menuItems.append(["Resolution: ", resolutionStr])
                }
            }
            print(track)
        }
        
        player.currentVideoSubTitleIndex = 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoInfoCell", for: indexPath) as? VideoInfoCell{
            
            cell.setup(menuItem: menuItems[indexPath.row])
            return cell
        }
        
        return VideoInfoCell()
    }

}
