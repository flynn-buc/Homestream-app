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
    
    private var component: UIControl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setComponent(text: String, component: UIControl){
        self.label?.text = text
        
        self.addSubview(component)
        component.translatesAutoresizingMaskIntoConstraints = false
        component.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        component.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.component = component
        
        self.selectionStyle = .none
        
        if component is UISwitch {
            print(" I am a switch")
        }
        
        if component is UITextField {
            isTextField = true
            //component.isHidden = true
            
        }
    }
    
    func getComponentIfTextField() -> UITextField?{
        if let component  = component as? UITextField {
            return component
        }
        return nil
    }
    
    
}
