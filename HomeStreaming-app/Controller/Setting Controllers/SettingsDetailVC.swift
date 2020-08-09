//
//  SettingsDetailVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/3/20.
//

import UIKit

class SettingsDetailVC: UITableViewController {
    
    
    @IBOutlet var settingsOptionsTable: UITableView!
    
    private var text: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsOptionsTable.delegate = self
        settingsOptionsTable.dataSource = self
    }
    
    // Call configure view if segue has set the required model
    var menuItems: [SettingsOptionCellModel]?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        loadViewIfNeeded()
        if menuItems != nil {
            self.settingsOptionsTable.reloadData()
        }
    }
    
    // set title of naviguation controller
    func set(title: String){
        loadViewIfNeeded()
    }
    
    //Will return 0 if no menus have been added to particular section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    // Should only have one section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menuItems = menuItems{
            let cellModel = menuItems[indexPath.row]
            cellModel.component.tag = indexPath.row
            menuItems[indexPath.row].component.tag = indexPath.row
            if let textField = cellModel.component as? UITextField{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsOptionTextCell") as? SettingsOptionTextfieldCell{
                    cell.updateViews(cellModel: cellModel, textField: textField)
                    return cell
                }
            }
            if let uiSwitch = cellModel.component as? UISwitch{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsOptionSwitchCell") as? SettingsOptionSwitchCell{
                    cell.updateViews(cellModel: cellModel, uiSwitch: uiSwitch)
                    return cell
                }
            }
            
        }
        return SettingsOptionCell()
    }
    // cell can be edited if the component is a UITextField
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return menuItems?[indexPath.row].component is UITextField
    }
    
    // Set UITextField in selected cell to be first responder when cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsOptionTextfieldCell,
           let component = cell.getComponent() as? UITextField{
            component.isHidden = false
            component.becomeFirstResponder()
        }
    }
}
