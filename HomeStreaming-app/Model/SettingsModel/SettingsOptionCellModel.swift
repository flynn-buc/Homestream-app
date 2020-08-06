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
    public private(set) var key: UserDefaultKey
    
    init(title: String, component: UIControl, userDefaultKey key: UserDefaultKey){
        self.title = title
        self.component = component
        self.key = key
    }
    
}

class SwitchSettingsOptionCellModel: SettingsOptionCellModel {
    public private(set) var uiSwitch: UISwitch

    init(title: String, key: UserDefaultKey){
        uiSwitch = UISwitch()
        super.init(title: title, component: uiSwitch, userDefaultKey: key)
        
    }
}

class TextSettingsOptionCellModel: SettingsOptionCellModel{
    public private(set) var textField: UITextField
    
    init(title: String, key: UserDefaultKey){
        textField = UITextField()
        super.init(title: title, component: textField, userDefaultKey: key)
    }
}


