//
//  playButton.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/27/20.
//

import UIKit
import TransitionButton

@IBDesignable

///Represents an animated button that will be used to play a specified file
class PlayButton: TransitionButton{
    
    let buttonSymbol = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .medium))
    override func awakeFromNib() {
        spinnerColor = .systemBackground
        resetButton()
        clipsToBounds = true
    }
    
    /// Sets button back to its default dimensions, ensures it is round on iPad or rounded on iPhones
    func resetButton(){
        if (UIDevice.current.userInterfaceIdiom == .pad){
            layer.cornerRadius = frame.size.width/2
        }else{
            layer.cornerRadius = 5
        }
        self.setImage(buttonSymbol, for: .normal)
        
    }
}
