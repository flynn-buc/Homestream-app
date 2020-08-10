//
//  RoundedImageView.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/3/20.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    //Configure a slightly rounded image for decimal pad
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
