//
//  SettingsOptionTextfieldCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/9/20.
//

import UIKit

class SettingsOptionTextfieldCell: SettingsOptionCell {
    
    private var shouldDisplayKey: UserDefaultKey?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateViews(cellModel : SettingsOptionCellModel, textField: UITextField){
        self.shouldDisplayKey = cellModel.keyIfDisplayed
        super.updateViews(cellModel: cellModel)
        configureUITextField(textField, cellModel)
    }
    
    private func configureUITextField(_ component: UITextField, _ cellModel: SettingsOptionCellModel) {
        component.text = UserPrefs.data.string(forTextKey: cellModel.key) // get text from user preferences
        component.delegate = self
        component.textColor = .systemBlue
        component.leftAnchor.constraint(equalTo: self.label.rightAnchor).isActive = true
        component.textAlignment = .right
        component.clearButtonMode = .whileEditing
        component.autocorrectionType = .no
        component.attributedPlaceholder = NSAttributedString(string: getNSAttributtedString(for: cellModel.key, in: component))
        
        if let hasDisplayOption = cellModel.keyIfDisplayed, let shouldEnable = UserPrefs.data.bool(forSwitchKey: hasDisplayOption){
            enable(shouldEnable)
        }
    }
    
    private func getNSAttributtedString(for type:UserDefaultKey, in component:UITextField)-> String {
        switch type {
        case .localIP: component.keyboardType = .decimalPad; return "192.168.1.10"
        case .remoteIP: component.keyboardType = .decimalPad; return "217.17.50.122"
        case .port:  component.keyboardType = .numberPad; return "3004"
        case .username: return "myUserName"
        case .password: return "myPassword"
        default: return ""
        }
    }
    
    override func enable(_ shouldEnable: Bool){
        if shouldDisplayKey != nil{
            super.enable(shouldEnable)
            if let textField = super.getComponent() as? UITextField{
                self.label.isEnabled = shouldEnable
                textField.textColor = shouldEnable ? UIColor.systemBlue : UIColor.lightGray
            }
        }
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
