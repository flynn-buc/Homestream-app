//
//  SettingsOptionTextfieldCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/9/20.
//

import UIKit

class SettingsOptionTextfieldCell: SettingsOptionCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SettingsOptionTextfieldCell: UITextFieldDelegate{
    // Change color to black when editing begings
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
    }
    
    //Change color back to system blue when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor.systemBlue
        
        // Once text is updated, save text to preferences if it is not nil
        if let text = textField.text{
            UserPrefs.data.set(text, forTextKey: key)
            ClientService.instance.updateAddress()
        }
    }
}
