//
//  RoundImageView.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/24/20.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
        //layer.borderColor = #colorLiteral(red: 0.1433575451, green: 0.1433575451, blue: 0.1433575451, alpha: 1)
        //layer.borderWidth = 0.8
    }
}
