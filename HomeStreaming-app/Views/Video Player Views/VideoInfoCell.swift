//
//  VideoInfoCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/12/20.
//

import UIKit

class VideoInfoCell: UICollectionViewCell {

    var isHeightCalculated: Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuValue: UILabel!
    
    
    func setup(menuItem: [String]){
        
        titleLabel.text = menuItem[0]
        menuValue.text = menuItem[1]
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isHeightCalculated {
                setNeedsLayout()
                layoutIfNeeded()
                let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
                var newFrame = layoutAttributes.frame
                newFrame.size.width = CGFloat(ceilf(Float(size.width)))
                layoutAttributes.frame = newFrame
                isHeightCalculated = true
            }
            return layoutAttributes
    }
}
