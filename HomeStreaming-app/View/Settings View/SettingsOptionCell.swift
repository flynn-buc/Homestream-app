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
    internal var key: UserDefaultKey!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Update cell with required data
    //Expects a component in the model, component should be a switch or a text field (subclasses from UIControl)
    
    func updateViews(cellModel : SettingsOptionCellModel){
        self.label?.text = cellModel.title
        self.component = cellModel.component
        self.addSubview(component)
        
        //Constraints
        component.translatesAutoresizingMaskIntoConstraints = false
        component.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        component.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.selectionStyle = .none //Cell should not be selected
        self.key = cellModel.key
        
        // Component settings when component is a textField
        if let component = component as? UITextField {
            configureUITextField(component, cellModel)
            
            //Component settings when component is a switch
        } else if let component = component as? UISwitch {
            configureUISwitch(component)
            
        }
        
        // If cell should be hidden due to a switch toggle, get the key from preferences and set the current value
        if let hasDisplayOption = cellModel.keyIfDisplayed, let shouldEnable = UserPrefs.data.bool(forSwitchKey: hasDisplayOption){
            enable(shouldEnable: shouldEnable)
        }
    }
}

// Extensions relating to a text field component
extension SettingsOptionCell {
    
    //UITextField display configuration
    private func configureUITextField(_ component: UITextField, _ cellModel: SettingsOptionCellModel) {
        component.text = userData.string(forKey: self.key.rawValue) // get text from user preferences
        //component.delegate = self
        component.textColor = .systemBlue
        component.leftAnchor.constraint(equalTo: self.label.rightAnchor).isActive = true
        component.textAlignment = .right
        component.clearButtonMode = .whileEditing
        component.autocorrectionType = .no
        component.attributedPlaceholder = NSAttributedString(string: getNSAttributtedString(for: cellModel.key))
    }
    
    // return component reference as UITextField to caller
    func getComponentIfTextField() -> UITextField?{
        return component as? UITextField
    }
    
    private func getNSAttributtedString(for type:UserDefaultKey)-> String {
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
}


//Extension when cell is a switch
extension SettingsOptionCell{
    //UISwitch Display configuration
    private func configureUISwitch(_ component: UISwitch) {
        component.isOn = switchesData.bool(forKey: self.key.rawValue)
        component.addTarget(self, action: #selector(switchToggled), for: UIControl.Event.valueChanged)
    }
    
    // Callback option from the switch, reload data (in case switch toggles cell visibility
    @objc func switchToggled(cellSwitch: UISwitch){
        switchesData.set(cellSwitch.isOn, forKey: key.rawValue)
        if let parent = superview?.superview as? UITableView {
            parent.reloadData()
        }
    }
}

// Extensions related to general display options for cells
extension SettingsOptionCell {
    private func enable(shouldEnable: Bool){
        component.isUserInteractionEnabled =  shouldEnable
        component.isEnabled = shouldEnable
        if let component = self.component as? UITextField {
            self.label.isEnabled = shouldEnable
            component.textColor = shouldEnable ? UIColor.systemBlue : UIColor.lightGray
        }
    }
}
