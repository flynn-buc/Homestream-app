//
//  playButton.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/27/20.
//

import UIKit
import TransitionButton

@IBDesignable
class PlayButton: TransitionButton{
    override func awakeFromNib() {
        spinnerColor = UIColor.systemIndigo
        clipsToBounds = true
    }
}
