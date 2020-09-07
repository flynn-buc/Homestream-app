//
//  OutlinedLabel.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/31/20.
//

import UIKit

@IBDesignable
class OutlinedLabel: CustomUILabel {

    override func awakeFromNib() {
        attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: stroke(font: self.font, strokeWidth: 2.0, insideColor: UIColor.black, strokeColor: UIColor.white))
    }
    
}


public func stroke(font: UIFont, strokeWidth: Float, insideColor: UIColor, strokeColor: UIColor) -> [NSAttributedString.Key: Any]{
    return [
        NSAttributedString.Key.strokeColor : strokeColor,
        NSAttributedString.Key.foregroundColor : insideColor,
        NSAttributedString.Key.strokeWidth : -strokeWidth,
        NSAttributedString.Key.font : font
        ]
}
