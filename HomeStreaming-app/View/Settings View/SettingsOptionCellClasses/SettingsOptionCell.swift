//
//  SettingsOptionCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/4/20.
//

import UIKit

internal class SettingsOptionCell: UITableViewCell {
    private var component: UIControl!
    internal var key: UserDefaultKey!
    internal var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label = UILabel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupConstraints(){
        
    }
    
    //Update cell with required data
    //Expects a component in the model, component should be a subclass of UIControl
    func updateViews(cellModel : SettingsOptionCellModel){
        label.text = cellModel.title
        component = cellModel.component
        self.addSubview(label)
        self.addSubview(component)
        
        
        //Constraints
        let margins = self.layoutMarginsGuide
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        component.translatesAutoresizingMaskIntoConstraints = false
        component.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        component.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        self.selectionStyle = .none //Cell should not be selected
        self.key = cellModel.key
        
        // If cell should be hidden due to a switch toggle, get the key from preferences and set the current value
        if let hasDisplayOption = cellModel.keyIfDisplayed, let shouldEnable = UserPrefs.data.bool(forSwitchKey: hasDisplayOption){
            enable(shouldEnable)
        }
    }
    
    // return component reference as UITextField to caller
    func getComponent() -> UIControl{
        return component
    }
    
    internal func enable(_ shouldEnable: Bool){
        component.isUserInteractionEnabled =  shouldEnable
        component.isEnabled = shouldEnable
    }
}
