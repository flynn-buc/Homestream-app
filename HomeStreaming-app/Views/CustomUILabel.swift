//
//  CustomLabel.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/29/20.
//

import Foundation

private  struct FontNames{
    let regular = "Avenir"
    let bold = "Avenir Heavy"
    let medium = "Avenir Medium"
    let italic = " Oblique"
    let light = "Avenir Book"
}


/// Represent a UILabel which will automatically use the fonts defined above, based on the style set
/// Relies on the font being designed in IB to be left to system font
@IBDesignable
public class CustomUILabel: UILabel {

    public override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureLabel()
    }

    func configureLabel() {
        let fonts = FontNames()
        var name = fonts.regular
        if font.isBold{
            name = fonts.bold
        }else if font.isLight{
            name = fonts.light
        }else if font.isMedium{
            name = fonts.medium
        }
        
        if font.isItalic{
            name.append(fonts.italic)
        }
        font = UIFont(name: name, size: self.font.pointSize)
    }
}

private extension UIFont{
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool{
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    var isLight: Bool {
        return fontName.contains("light")
    }
    
    var isMedium: Bool{
        return fontName.contains("medium")
    }
}
