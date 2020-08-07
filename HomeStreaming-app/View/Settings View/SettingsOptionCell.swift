//
//  SettingsOptionCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/4/20.
//

import UIKit

class SettingsOptionCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    private var switchesData: UserDefaults!
    private var userData: UserDefaults!
    
    private var component: UIControl!
    private var key: UserDefaultKey!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        switchesData = UserDefaults.init(suiteName: "Switch Toggles")
        userData = UserDefaults.init(suiteName: "User Data")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setComponent(cellModel : SettingsOptionCellModel){
        self.label?.text = cellModel.title
        self.component = cellModel.component
        self.addSubview(component)
        
        component.translatesAutoresizingMaskIntoConstraints = false
        component.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        component.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.selectionStyle = .none
        self.key = cellModel.key
        
        if let component = component as? UITextField {
            component.text = userData.string(forKey: self.key.rawValue)
            component.delegate = self
            component.textColor = .systemBlue
            component.leftAnchor.constraint(equalTo: self.label.rightAnchor).isActive = true
            component.textAlignment = .right
            component.clearButtonMode = .whileEditing
            component.autocorrectionType = .no
            component.attributedPlaceholder = NSAttributedString(string: getNSAttributtedString(for: cellModel.key))
            
        } else if let component = component as? UISwitch {
            component.isOn = switchesData.bool(forKey: self.key.rawValue)
            component.addTarget(self, action: #selector(switchToggled), for: UIControl.Event.valueChanged)
            
        }
        
        if let hasDisplayOption = cellModel.keyIfDisplayed{
            enable(shouldEnable: switchesData.bool(forKey: hasDisplayOption.rawValue))
        }
    }
}

extension SettingsOptionCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor.systemBlue

        if let text = textField.text{
            userData.set(text, forKey: key.rawValue)
            ClientService.instance.updateAddress()
        }
    }
    
    func getComponentIfTextField() -> UITextField?{
        return component as? UITextField
    }
}

extension SettingsOptionCell {
    func getNSAttributtedString(for type:UserDefaultKey)-> String {
        
        guard let component = self.component as? UITextField else {return ""}
        switch type {
        case .localIP: component.keyboardType = .decimalPad; return "192.168.1.10"
        case .remoteIP: component.keyboardType = .decimalPad; return "217.17.50.122"
        case .port:  component.keyboardType = .numberPad; return "3004"
        case .username: return "myUserName"
        case .password: return "myPassword"
        default: return ""
        }
    }
    
    @objc func switchToggled(cellSwitch: UISwitch){
        switchesData.set(cellSwitch.isOn, forKey: key.rawValue)
        guard let parent = superview?.superview as? UITableView else {return}
        parent.reloadData()
    }
    
    func enable(shouldEnable: Bool){
        component.isUserInteractionEnabled =  shouldEnable
        component.isEnabled = shouldEnable
        if let component = self.component as? UITextField {
            self.label.isEnabled = shouldEnable
            if (shouldEnable){
                component.textColor = UIColor.systemBlue
            }else{
                print("should disable color)")
                component.textColor = UIColor.lightGray
            }
        }
    }
}
