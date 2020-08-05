//
//  SettingsOptionCellModel.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/4/20.
//

import UIKit

class SettingsOptionCellModel {
    public private(set) var title: String
    public private(set) var component: UIControl
    
    init(title: String, component: UIControl){
        self.title = title
        self.component = component
    }
    
}

class SwitchSettingsOptionCellModel: SettingsOptionCellModel {
    public private(set) var uiSwitch: UISwitch
    
     init(title: String){
        uiSwitch = UISwitch()
        super.init(title: title, component: uiSwitch)
        
    }
}

class TextSettingsOptionCellModel: SettingsOptionCellModel{
    public private(set) var textField: UITextField
    
     init(title: String){
        textField = UITextField()
        super.init(title: title, component: textField)
    }
}


