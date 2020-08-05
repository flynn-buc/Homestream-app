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
        

        // Do any additional setup after loading the view.
    }
    
    var menuItems: [SettingsOptionCellModel]?{
        didSet{
            configureView()
        }
    }
    
    
    func configureView(){
        loadViewIfNeeded()
        if menuItems != nil {
            self.settingsOptionsTable.reloadData()
            if settingsOptionsTable == nil{
                print("Table is nil but idk why")
            }
        }
    }
    
    func set(title: String){
        loadViewIfNeeded()
        text = title
        print(title)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsOptionCell") as? SettingsOptionCell{
            if let menuItems = menuItems{
                print(menuItems[indexPath.row].title)
                menuItems[indexPath.row].component.tag = indexPath.row
                cell.setComponent(text: menuItems[indexPath.row].title, component: menuItems[indexPath.row].component)
                return cell
            }
            
        }
        return SettingsOptionCell()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return menuItems?[indexPath.row].component is UITextField
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsOptionCell {
            cell.getComponentIfTextField()?.isHidden = false
            cell.getComponentIfTextField()?.becomeFirstResponder()
        }
    }
}
