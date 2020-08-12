//
//  SmallSlider.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/11/20.
//

import UIKit
@IBDesignable
class SmallSlider: UISlider {

    
    override func awakeFromNib() {
        print("Here")
        setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        setThumbImage(UIImage(named: "thumb.png"), for: .highlighted)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
