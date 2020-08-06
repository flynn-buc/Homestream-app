//
//  SettingsOptionCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/4/20.
//

import UIKit

class SettingsOptionCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    
    public private(set) var isTextField = false;
    
    private var component: UIControl!
    private var key: UserDefaultKey!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        if component is UISwitch {
            print(" I am a switch")
        }
        
        if let component = component as? UITextField {
            component.text = UserDefaults.standard.string(forKey: self.key.rawValue)
            isTextField = true
            component.delegate = self
            component.textColor = .systemBlue
            component.leftAnchor.constraint(equalTo: self.label.rightAnchor).isActive = true
            component.textAlignment = .right
            component.clearButtonMode = .whileEditing
            component.autocorrectionType = .no
            component.attributedPlaceholder = NSAttributedString(string: getNSAttributtedString(for: cellModel.key))
        }
        
        if let component = component as? UISwitch{
            component.isOn = UserDefaults.standard.bool(forKey: self.key.rawValue)
            component.addTarget(self, action: #selector(switchToggled), for: UIControl.Event.valueChanged)
            
        }
        
    }
    
    
    func getComponentIfTextField() -> UITextField?{
        if let component  = component as? UITextField {
            return component
        }
        return nil
    }
}

extension SettingsOptionCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor.systemBlue
        
        if let text = textField.text{
            UserDefaults.standard.set(text, forKey: key.rawValue)
        }
    }
}


extension SettingsOptionCell {
    
   @objc func switchToggled(cellSwitch: UISwitch){
        UserDefaults.standard.set(cellSwitch.isOn, forKey: key.rawValue)
    }
    
}

extension SettingsOptionCell {
    func getNSAttributtedString(for type:UserDefaultKey)-> String {
        switch type {
        case .localIP: return "192.168.1.10"
        case .remoteIP: return "217.17.50.122"
        case .port: return "3004"
        case .username: return "myUserName"
        case .password: return "myPassword"
        default: return ""
        }
    }
    
}
