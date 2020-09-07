//
//  PosterCollectionView.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/23/20.
//

import UIKit
import Blueprints

class PosterCollectionView: UICollectionView {
    
    /// Returns whether the current device is in portrait or landscape
    /// - Returns: boolean value, true if device is in portrait, and true if no information is available
    private func isPortrait()->Bool{
        if  let size = self.superview?.frame.size{
            return (size.width < size.height)
        }
        return true
    }
    
    ///Defines a cell layout using Blueprints, which adapts to both horizontal and vertical devices, on both iPhones and iPads
    /// displays items vertically
    /// - Returns: VerticalCellLayout
    func getVerticalCellLayout()->BlueprintLayout{
        let isPortrait = self.isPortrait()
       
        var itemsPerRow:CGFloat = 3.0
        var height: CGFloat = 225
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
                itemsPerRow = 5.0
            }else{
                itemsPerRow = 6.0
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
        
        return blueprintLayout
    }
    
    ///Defines a cell layout using Blueprints, which adapts to both horizontal and vertical devices, on both iPhones and iPads
    /// displays items horizontally
    /// - Returns: VerticalCellLayout
    func getHorizontalCellLayout()->BlueprintLayout{
        let isPortrait = self.isPortrait()
        
        var itemsPerRow:CGFloat = 3.0
        var height: CGFloat = 180
        var interItemSpacing: CGFloat = 10
        var lineSpacing: CGFloat = 10
        var insets = EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            if isPortrait{
                itemsPerRow = 2.0
                height = 115
                lineSpacing = 10
            }else{
                itemsPerRow = 3.0
                height = 150
                interItemSpacing = 5
                insets.left = 5
                insets.right = 5
            }
        }else{
            if isPortrait{
                itemsPerRow = 3.0
            }else{
                itemsPerRow = 4.0
            }
        }
        
        let layout = VerticalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            height: height,
            minimumInteritemSpacing: interItemSpacing,
            minimumLineSpacing: lineSpacing,
            sectionInset: insets,
            stickyHeaders: true,
            stickyFooters: false)
        
        
        return layout
        
    }
}
