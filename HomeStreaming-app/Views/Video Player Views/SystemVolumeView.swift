//
//  SystemVolumeView.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/12/20.
//

import UIKit
import MediaPlayer
/// Extend the default MPVolumeView to change the tint color and ensure it remains within the specified bound (workaround)
class SystemVolumeView: MPVolumeView {
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.volumeSliderRect(forBounds: bounds)
        newBounds.origin.y = bounds.origin.y
        newBounds.size.height = bounds.size.height
        return newBounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = UIColor.systemIndigo
        
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
}
