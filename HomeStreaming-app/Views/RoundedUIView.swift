//
//  RoundedUIView.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/10/20.
//

import UIKit

@IBDesignable

class RoundedUIView: UIView{
    override func awakeFromNib() {
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
}
