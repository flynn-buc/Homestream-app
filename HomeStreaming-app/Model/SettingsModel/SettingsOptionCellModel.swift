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
    public private(set) var keyIfDisplayed: UserDefaultKey?
    
    init(title: String, component: UIControl, userDefaultKey key: UserDefaultKey, keyIfDisplayed: UserDefaultKey? = nil){
        self.title = title
        self.component = component
        self.key = key
        self.keyIfDisplayed = keyIfDisplayed
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
    
    init(title: String, key: UserDefaultKey, keyIfDisplayed: UserDefaultKey? = nil){
        textField = UITextField()
        super.init(title: title, component: textField, userDefaultKey: key, keyIfDisplayed: keyIfDisplayed)
    }
}


