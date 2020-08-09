//
//  DecimalPadButton.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/6/20.
//

import UIKit


@IBDesignable

class DecimalPadButton: UIButton {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10.0
        backgroundColor = UIColor.white
        setTitleColor(UIColor.black, for: .normal)
        setTitleColor(UIColor.black, for: .highlighted)
        setTitleColor(UIColor.black, for: .focused)
        tintColor = UIColor.black
        titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
    }
}

extension DecimalPadButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : UIColor.white
        }
    }
}
