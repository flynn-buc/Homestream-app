//
//  UICollectionFlowLayoutDelegate.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import UIKit

class CollectionViewDelegateWithLayout: NSObject, UICollectionViewDelegate {
    //Adjust cell size for iphones
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize:CGSize = CGSize(width: 164, height: 152)
        if UIDevice.current.userInterfaceIdiom == .phone{
            let screenSize: CGRect = UIScreen.main.bounds
            var width = 0
            var height = 0
            if screenSize.width > screenSize.height{
                height = Int(screenSize.height/3.3)
                width = Int(Float(height)/(164.0/152.0))
            }else{
                width = Int(screenSize.width/3.3)
                height = Int(Float(width)/(164.0/152.0))
            }
            cellSize = CGSize(width: width, height: height)
        }
        return cellSize
    }
}
