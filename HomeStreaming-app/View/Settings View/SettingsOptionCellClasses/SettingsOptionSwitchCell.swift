//
//  SettingsOptionSwitchCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/9/20.
//

import UIKit

class SettingsOptionSwitchCell: SettingsOptionCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateViews(cellModel : SettingsOptionCellModel, uiSwitch: UISwitch){
       super.updateViews(cellModel: cellModel)
        uiSwitch.isOn = UserPrefs.data.bool(forSwitchKey: self.key) ?? false
        uiSwitch.addTarget(self, action: #selector(switchToggled), for: UIControl.Event.valueChanged)
   }
    
    // Callback option from the switch, reload data (in case switch toggles cell visibility
    @objc func switchToggled(cellSwitch: UISwitch){
        UserPrefs.data.set(cellSwitch.isOn, forSwitchKey: self.key)
        if let parent = superview?.superview as? UITableView {
            parent.reloadData()
        }
    }
}
