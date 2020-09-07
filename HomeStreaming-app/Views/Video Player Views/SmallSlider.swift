//
//  SmallSlider.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/11/20.
//

import UIKit
@IBDesignable
class SmallSlider: UISlider {

    /// Adjust image on a UISlider to be smaller
    override func awakeFromNib() {
        setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        setThumbImage(UIImage(named: "thumb.png"), for: .highlighted)
    }
}
